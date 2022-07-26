{ stdenv, lib, fetchFromGitHub
, makeWrapper, unzip, which, writeTextFile
, curl, tzdata, gdb, Foundation, git, callPackage
, targetPackages, fetchpatch, bash
, HOST_DMD? "${callPackage ./bootstrap.nix { }}/bin/dmd"
, version? "2.097.2"
, dmdSha256? "16ldkk32y7ln82n7g2ym5d1xf3vly3i31hf8600cpvimf6yhr6kb"
, druntimeSha256? "1sayg6ia85jln8g28vb4m124c27lgbkd6xzg9gblss8ardb8dsp1"
, phobosSha256? "0czg13h65b6qwhk9ibya21z3iv3fpk3rsjr3zbcrpc2spqjknfw5"
}:

let
  dmdConfFile = writeTextFile {
    name = "dmd.conf";
    text = (lib.generators.toINI {} {
      Environment = {
        DFLAGS = ''-I@out@/include/dmd -L-L@out@/lib -fPIC ${lib.optionalString (!targetPackages.stdenv.cc.isClang) "-L--export-dynamic"}'';
      };
    });
  };

  bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
in

stdenv.mkDerivation rec {
  pname = "dmd";
  inherit version;

  enableParallelBuilding = true;

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = dmdSha256;
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "druntime";
      rev = "v${version}";
      sha256 = druntimeSha256;
      name = "druntime";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "phobos";
      rev = "v${version}";
      sha256 = phobosSha256;
      name = "phobos";
    })
  ];

  sourceRoot = ".";

  # https://issues.dlang.org/show_bug.cgi?id=19553
  hardeningDisable = [ "fortify" ];

  # Not using patches option to make it easy to patch, for example, dmd and
  # Phobos at same time if that's required
  patchPhase =

  # Migrates D1-style operator overloads in DMD source, to allow building with
  # a newer DMD
  lib.optionalString (lib.versionOlder version "2.088.0") ''
    patch -p1 -F3 --directory=dmd -i ${(fetchpatch {
      url = "https://github.com/dlang/dmd/commit/c4d33e5eb46c123761ac501e8c52f33850483a8a.patch";
      sha256 = "0rhl9h3hsi6d0qrz24f4zx960cirad1h8mm383q6n21jzcw71cp5";
    })}
  ''

  # Fixes C++ tests that compiled on older C++ but not on the current one
  + lib.optionalString (lib.versionOlder version "2.092.2") ''
    patch -p1 -F3 --directory=druntime -i ${(fetchpatch {
      url = "https://github.com/dlang/druntime/commit/438990def7e377ca1f87b6d28246673bb38022ab.patch";
      sha256 = "0nxzkrd1rzj44l83j7jj90yz2cv01na8vn9d116ijnm85jl007b4";
    })}
  ''

  + postPatch;


  postPatch =
  ''
    patchShebangs .
  ''

  # This one has tested against a hardcoded year, then against a current year on
  # and off again. It just isn't worth it to patch all the historical versions
  # of it, so just remove it until the most recent change.
  + lib.optionalString (lib.versionOlder version "2.091.0") ''
    rm dmd/test/compilable/ddocYear.d
  ''

  + lib.optionalString (version == "2.092.1") ''
    rm dmd/test/dshell/test6952.d
  '' + lib.optionalString (lib.versionAtLeast version "2.092.2") ''
    substituteInPlace dmd/test/dshell/test6952.d --replace "/usr/bin/env bash" "${bash}/bin/bash"
  ''

  + ''
    rm dmd/test/runnable/gdb1.d
    rm dmd/test/runnable/gdb10311.d
    rm dmd/test/runnable/gdb14225.d
    rm dmd/test/runnable/gdb14276.d
    rm dmd/test/runnable/gdb14313.d
    rm dmd/test/runnable/gdb14330.d
    rm dmd/test/runnable/gdb15729.sh
    rm dmd/test/runnable/gdb4149.d
    rm dmd/test/runnable/gdb4181.d

    # Grep'd string changed with gdb 12
    substituteInPlace druntime/test/exceptions/Makefile \
      --replace 'in D main (' 'in _Dmain ('
  ''

  + lib.optionalString stdenv.isLinux ''
    substituteInPlace phobos/std/socket.d --replace "assert(ih.addrList[0] == 0x7F_00_00_01);" ""
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace phobos/std/socket.d --replace "foreach (name; names)" "names = []; foreach (name; names)"
  '';

  nativeBuildInputs = [ makeWrapper unzip which git ];

  buildInputs = [ gdb curl tzdata ]
    ++ lib.optional stdenv.isDarwin [ Foundation gdb ];


  osname = if stdenv.isDarwin then
    "osx"
  else
    stdenv.hostPlatform.parsed.kernel.name;
  top = "$NIX_BUILD_TOP";
  pathToDmd = "${top}/dmd/generated/${osname}/release/${bits}/dmd";

  # Build and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
    cd dmd
    make -j$NIX_BUILD_CORES -f posix.mak INSTALL_DIR=$out BUILD=release ENABLE_RELEASE=1 PIC=1 HOST_DMD=${HOST_DMD}
    cd ../druntime
    make -j$NIX_BUILD_CORES -f posix.mak BUILD=release ENABLE_RELEASE=1 PIC=1 INSTALL_DIR=$out DMD=${pathToDmd}
    cd ../phobos
    echo ${tzdata}/share/zoneinfo/ > TZDatabaseDirFile
    echo ${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary} > LibcurlPathFile
    make -j$NIX_BUILD_CORES -f posix.mak BUILD=release ENABLE_RELEASE=1 PIC=1 INSTALL_DIR=$out DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$(pwd)"
    cd ..
  '';

  doCheck = true;

  # many tests are disbled because they are failing

  # NOTE: Purity check is disabled for checkPhase because it doesn't fare well
  # with the DMD linker. See https://github.com/NixOS/nixpkgs/issues/97420
  checkPhase = ''
    cd dmd
    NIX_ENFORCE_PURITY= \
      make -j$NIX_BUILD_CORES -C test -f Makefile PIC=1 CC=$CXX DMD=${pathToDmd} BUILD=release SHELL=$SHELL

    cd ../druntime
    NIX_ENFORCE_PURITY= \
      make -j$NIX_BUILD_CORES -f posix.mak unittest PIC=1 DMD=${pathToDmd} BUILD=release

    cd ../phobos
    NIX_ENFORCE_PURITY= \
      make -j$NIX_BUILD_CORES -f posix.mak unittest BUILD=release ENABLE_RELEASE=1 PIC=1 DMD=${pathToDmd} DFLAGS="-version=TZDatabaseDir -version=LibcurlPath -J$(pwd)"

    cd ..
  '';

  installPhase = ''
    cd dmd
    mkdir $out
    mkdir $out/bin
    cp ${pathToDmd} $out/bin

    mkdir -p $out/share/man/man1
    mkdir -p $out/share/man/man5
    cp -r docs/man/man1/* $out/share/man/man1/
    cp -r docs/man/man5/* $out/share/man/man5/

    cd ../druntime
    mkdir $out/include
    mkdir $out/include/dmd
    cp -r import/* $out/include/dmd

    cd ../phobos
    mkdir $out/lib
    cp generated/${osname}/release/${bits}/libphobos2.* $out/lib

    cp -r std $out/include/dmd
    cp -r etc $out/include/dmd

    wrapProgram $out/bin/dmd \
      --prefix PATH ":" "${targetPackages.stdenv.cc}/bin" \
      --set-default CC "${targetPackages.stdenv.cc}/bin/cc"

    substitute ${dmdConfFile} "$out/bin/dmd.conf" --subst-var out
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Official reference compiler for the D language";
    homepage = "https://dlang.org/";
    # Everything is now Boost licensed, even the backend.
    # https://github.com/dlang/dmd/pull/6680
    license = licenses.boost;
    maintainers = with maintainers; [ ThomasMader lionello dukc ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
