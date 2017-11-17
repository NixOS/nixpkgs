{ stdenv, fetchFromGitHub
, makeWrapper, unzip, which
, curl, tzdata
}:

stdenv.mkDerivation rec {
  name = "dmd-${version}";
  # This is the last version of dmd which is buildable without a D compiler.
  # So we use this as a bootstrap version.
  # The DMD frontend has been ported to D in 2.069.0 but idgen was already
  # ported in 2.068.0.
  version = "2.067.1";

  srcs = [
  (fetchFromGitHub {
    owner = "dlang";
    repo = "dmd";
    rev = "v${version}";
    sha256 = "0fm29lg8axfmzdaj0y6vg70lhwb5d9rv4aavnvdd15xjschinlcz";
    name = "dmd-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "dlang";
    repo = "druntime";
    rev = "v${version}";
    sha256 = "1n2qfw9kmnql0fk2nxikispqs7vh85nhvyyr00fk227n9lgnqf02";
    name = "druntime-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "dlang";
    repo = "phobos";
    rev = "v${version}";
    sha256 = "0fywgds9xvjcgnqxmpwr67p3wi2m535619pvj159cgwv5y0nr3p1";
    name = "phobos-v${version}-src";
  })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd-v${version}-src dmd
      mv druntime-v${version}-src druntime
      mv phobos-v${version}-src phobos
  '';

  # Compile with PIC to prevent colliding modules with binutils 2.28.
  # https://issues.dlang.org/show_bug.cgi?id=17375
  usePIC = "-fPIC";
  ROOT_HOME_DIR = "$(echo ~root)";

  postPatch = ''
      # Ugly hack so the dlopen call has a chance to succeed.
      # https://issues.dlang.org/show_bug.cgi?id=15391
      substituteInPlace phobos/std/net/curl.d \
          --replace libcurl.so ${curl.out}/lib/libcurl.so

      # Ugly hack to fix the hardcoded path to zoneinfo in the source file.
      # https://issues.dlang.org/show_bug.cgi?id=15391
      substituteInPlace phobos/std/datetime.d \
          --replace /usr/share/zoneinfo/ ${tzdata}/share/zoneinfo/

      substituteInPlace druntime/test/shared/Makefile \
          --replace "DFLAGS:=" "DFLAGS:=${usePIC} "

      # phobos uses curl, so we need to patch the path to the lib.
      substituteInPlace phobos/posix.mak \
          --replace "-soname=libcurl.so.4" "-soname=${curl.out}/lib/libcurl.so.4"

      # Use proper C++ compiler
      substituteInPlace dmd/src/posix.mak \
          --replace g++ $CXX
  ''

  + stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace dmd/src/root/port.c \
        --replace "#include <bits/mathdef.h>" "#include <complex.h>"

      # See https://github.com/NixOS/nixpkgs/issues/29443
      substituteInPlace phobos/std/path.d \
          --replace "\"/root" "\"${ROOT_HOME_DIR}"
  ''

  + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace dmd/src/posix.mak \
          --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_

      # Was not able to compile on darwin due to "__inline_isnanl"
      # being undefined.
      substituteInPlace dmd/src/root/port.c --replace __inline_isnanl __inline_isnan
  '';

  nativeBuildInputs = [ makeWrapper unzip which ];
  buildInputs = [ curl tzdata ];

  # Buid and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
      cd dmd
      make -f posix.mak INSTALL_DIR=$out
      export DMD=$PWD/src/dmd
      cd ../druntime
      make -f posix.mak PIC=${usePIC} INSTALL_DIR=$out DMD=$DMD
      cd ../phobos
      make -f posix.mak PIC=${usePIC} INSTALL_DIR=$out DMD=$DMD
      cd ..
  '';

  # disable check phase because some tests are not working with sandboxing
  doCheck = false;

  checkPhase = ''
      cd dmd
      export DMD=$PWD/src/dmd
      cd ../druntime
      make -f posix.mak unittest PIC=${usePIC} DMD=$DMD BUILD=release
      cd ../phobos
      make -f posix.mak unittest PIC=${usePIC} DMD=$DMD BUILD=release
      cd ..
  '';

  installPhase = ''
      cd dmd
      mkdir $out
      mkdir $out/bin
      cp $PWD/src/dmd $out/bin
      mkdir -p $out/share/man/man1
      mkdir -p $out/share/man/man5
      cp -r docs/man/man1/* $out/share/man/man1/
      cp -r docs/man/man5/* $out/share/man/man5/

      cd ../druntime
      mkdir $out/include
      mkdir $out/include/d2
      cp -r import/* $out/include/d2

      cd ../phobos
      mkdir $out/lib
      ${
          let bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
          osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name;
          extension = if stdenv.hostPlatform.isDarwin then "a" else "{a,so}"; in
          "cp generated/${osname}/release/${bits}/libphobos2.${extension} $out/lib"
      }

      cp -r std $out/include/d2
      cp -r etc $out/include/d2

      wrapProgram $out/bin/dmd \
          --prefix PATH ":" "${stdenv.cc}/bin" \
          --set-default CC "$CC"

      cd $out/bin
      tee dmd.conf << EOF
      [Environment]
      DFLAGS=-I$out/include/d2 -L-L$out/lib ${stdenv.lib.optionalString (!stdenv.cc.isClang) "-L--export-dynamic"} -fPIC
      EOF
  '';

  meta = with stdenv.lib; {
    description = "Official reference compiler for the D language";
    homepage = http://dlang.org/;
    # Everything is now Boost licensed, even the backend.
    # https://github.com/dlang/dmd/pull/6680
    license = licenses.boost;
    platforms = platforms.unix;
  };
}

