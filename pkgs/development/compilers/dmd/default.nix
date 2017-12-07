{ stdenv, fetchFromGitHub
, makeWrapper, unzip, which
, curl, tzdata, gdb, darwin
# Versions 2.070.2 and up require a working dmd compiler to build:
, bootstrapDmd }:

stdenv.mkDerivation rec {
  name = "dmd-${version}";
  version = "2.075.1";

  srcs = [
  (fetchFromGitHub {
    owner = "dlang";
    repo = "dmd";
    rev = "v${version}";
    sha256 = "0kq6r8rcghvzk5jcphg89l85rg734s29bssd2rcw3fygx0k9a9k5";
    name = "dmd-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "dlang";
    repo = "druntime";
    rev = "v${version}";
    sha256 = "0idn2v1lmp7hl637g3i7pdfj9mjk4sclkz4cm77nl8873k2fhk8j";
    name = "druntime-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "dlang";
    repo = "phobos";
    rev = "v${version}";
    sha256 = "1a7q5fd15yspgs5plxgx54jyrcwgzlyw3rahmz04jd2s5h56dj04";
    name = "phobos-v${version}-src";
  })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd-v${version}-src dmd
      mv druntime-v${version}-src druntime
      mv phobos-v${version}-src phobos

      # Remove cppa test for now because it doesn't work.
      rm dmd/test/runnable/cppa.d
      rm dmd/test/runnable/extra-files/cppb.cpp
  '';

  # Compile with PIC to prevent colliding modules with binutils 2.28.
  # https://issues.dlang.org/show_bug.cgi?id=17375
  usePIC = "-fPIC";

  postPatch = ''
      # Ugly hack so the dlopen call has a chance to succeed.
      # https://issues.dlang.org/show_bug.cgi?id=15391
      substituteInPlace phobos/std/net/curl.d \
          --replace libcurl.so ${curl.out}/lib/libcurl.so

      # Ugly hack to fix the hardcoded path to zoneinfo in the source file.
      # https://issues.dlang.org/show_bug.cgi?id=15391
      substituteInPlace phobos/std/datetime/timezone.d \
          --replace /usr/share/zoneinfo/ ${tzdata}/share/zoneinfo/

      substituteInPlace druntime/test/common.mak \
          --replace "DFLAGS:=" "DFLAGS:=${usePIC} "

      # phobos uses curl, so we need to patch the path to the lib.
      substituteInPlace phobos/posix.mak \
          --replace "-soname=libcurl.so.4" "-soname=${curl.out}/lib/libcurl.so.4"

      # Use proper C++ compiler
      substituteInPlace dmd/posix.mak \
          --replace g++ $CXX
  ''

    + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace dmd/posix.mak \
            --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_
    '';

  nativeBuildInputs = [ bootstrapDmd makeWrapper unzip which gdb ]

  ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Foundation
  ]);

  buildInputs = [ curl tzdata ];

  # Buid and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
      cd dmd
      make -j$NIX_BUILD_CORES -f posix.mak INSTALL_DIR=$out
      ${
          let bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
          osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name; in
          "export DMD=$PWD/generated/${osname}/release/${bits}/dmd"
      }
      cd ../druntime
      make -j$NIX_BUILD_CORES -f posix.mak PIC=${usePIC} INSTALL_DIR=$out DMD=$DMD
      cd ../phobos
      make -j$NIX_BUILD_CORES -f posix.mak PIC=${usePIC} INSTALL_DIR=$out DMD=$DMD
      cd ..
  '';

  # disable check phase because some tests are not working with sandboxing
  doCheck = false;

  checkPhase = ''
      cd dmd
      ${
          let bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
          osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name; in
          "export DMD=$PWD/generated/${osname}/release/${bits}/dmd"
      }
      make -j$NIX_BUILD_CORES -C test -f Makefile PIC=${usePIC} DMD=$DMD BUILD=release SHARED=0
      cd ../druntime
      make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=${usePIC} DMD=$DMD BUILD=release
      cd ../phobos
      make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=${usePIC} DMD=$DMD BUILD=release
      cd ..
  '';

  installPhase = ''
      cd dmd
      mkdir $out
      mkdir $out/bin
      ${
          let bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
          osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name; in
          "cp $PWD/generated/${osname}/release/${bits}/dmd $out/bin"
      }

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
    maintainers = with maintainers; [ ThomasMader ];
    platforms = platforms.unix;
  };
}
