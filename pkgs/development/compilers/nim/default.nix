# https://nim-lang.github.io/Nim/packaging.html
# https://nim-lang.org/docs/nimc.html

{ lib, buildPackages, stdenv, fetchurl, fetchgit, fetchFromGitHub, makeWrapper
, openssl, pcre, readline, boehmgc, sqlite, nim-unwrapped }:

let
  parseCpu = platform:
    with platform;
    # Derive a Nim CPU identifier
    if isAarch32 then
      "arm"
    else if isAarch64 then
      "arm64"
    else if isAlpha then
      "alpha"
    else if isAvr then
      "avr"
    else if isMips && is32bit then
      "mips"
    else if isMips && is64bit then
      "mips64"
    else if isMsp430 then
      "msp430"
    else if isPowerPC && is32bit then
      "powerpc"
    else if isPowerPC && is64bit then
      "powerpc64"
    else if isRiscV && is64bit then
      "riscv64"
    else if isSparc then
      "sparc"
    else if isx86_32 then
      "i386"
    else if isx86_64 then
      "amd64"
    else
      abort "no Nim CPU support known for ${config}";

  parseOs = platform:
    with platform;
    # Derive a Nim OS identifier
    if isAndroid then
      "Android"
    else if isDarwin then
      "MacOSX"
    else if isFreeBSD then
      "FreeBSD"
    else if isGenode then
      "Genode"
    else if isLinux then
      "Linux"
    else if isNetBSD then
      "NetBSD"
    else if isNone then
      "Standalone"
    else if isOpenBSD then
      "OpenBSD"
    else if isWindows then
      "Windows"
    else if isiOS then
      "iOS"
    else
      abort "no Nim OS support known for ${config}";

  parsePlatform = p: {
    cpu = parseCpu p;
    os = parseOs p;
  };

  nimHost = parsePlatform stdenv.hostPlatform;
  nimTarget = parsePlatform stdenv.targetPlatform;

  bootstrapCompiler = stdenv.mkDerivation rec {
    pname = "nim-bootstrap";
    version = "0.20.0";

    src = fetchgit {
      # A Git checkout is much smaller than a GitHub tarball.
      url = "https://github.com/nim-lang/csources.git";
      rev = "v${version}";
      sha256 = "0i6vsfy1sgapx43n226q8m0pvn159sw2mhp50zm3hhb9zfijanis";
    };

    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall
      install -Dt $out/bin bin/nim
      runHook postInstall
    '';
  };

in {

  nim-unwrapped = stdenv.mkDerivation rec {
    pname = "nim-unwrapped";
    version = "1.4.4";
    strictDeps = true;

    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${version}.tar.xz";
      sha256 = "03k642nnjca0s6jlbn1v4jld51mbkix97jli4ky74gqlxyfp4wvd";
    };

    buildInputs = [ boehmgc openssl pcre readline sqlite ];

    patches = [
      ./NIM_CONFIG_DIR.patch
      # Override compiler configuration via an environmental variable

      ./nixbuild.patch
      # Load libraries at runtime by absolute path
    ];

    configurePhase = ''
      runHook preConfigure
      cp ${bootstrapCompiler}/bin/nim bin/
      echo 'define:nixbuild' >> config/nim.cfg
      runHook postConfigure
    '';

    kochArgs = [
      "--cpu:${nimHost.cpu}"
      "--os:${nimHost.os}"
      "-d:release"
      "-d:useGnuReadline"
    ] ++ lib.optional (stdenv.isDarwin || stdenv.isLinux) "-d:nativeStacktrace";

    buildPhase = ''
      runHook preBuild
      local HOME=$TMPDIR
      ./bin/nim c koch
      ./koch boot $kochArgs --parallelBuild:$NIX_BUILD_CORES
      ./koch toolsNoExternal $kochArgs --parallelBuild:$NIX_BUILD_CORES
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dt $out/bin bin/*
      ln -sf $out/nim/bin/nim $out/bin/nim
      ./install.sh $out
      runHook postInstall
    '';

    meta = with lib; {
      description = "Statically typed, imperative programming language";
      homepage = "https://nim-lang.org/";
      license = licenses.mit;
      maintainers = with maintainers; [ ehmry ];
    };
  };

  nimble-unwrapped = stdenv.mkDerivation rec {
    pname = "nimble-unwrapped";
    version = "0.13.1";
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v${version}";
      sha256 = "1idb4r0kjbqv16r6bgmxlr13w2vgq5332hmnc8pjbxiyfwm075x8";
    };

    depsBuildBuild = [ nim-unwrapped ];
    buildInputs = [ openssl ];

    nimFlags = [ "--cpu:${nimHost.cpu}" "--os:${nimHost.os}" "-d:release" ];

    buildPhase = ''
      runHook preBuild
      HOME=$NIX_BUILD_TOP nim c $nimFlags src/nimble
      runHook postBuild
    '';

    installPhase = ''
      runHook preBuild
      install -Dt $out/bin src/nimble
      runHook postBuild
    '';
  };

  nim = let
    nim' = buildPackages.nim-unwrapped;
    nimble' = buildPackages.nimble-unwrapped;
    inherit (stdenv) targetPlatform;
  in stdenv.mkDerivation {
    name = "${targetPlatform.config}-nim-wrapper-${nim'.version}";
    inherit (nim') version;
    preferLocalBuild = true;
    strictDeps = true;

    nativeBuildInputs = [ makeWrapper ];

    patches = [
      ./nim.cfg.patch
      # Remove configurations that clash with ours
    ];

    unpackPhase = ''
      runHook preUnpack
      tar xf ${nim'.src} nim-$version/config
      cd nim-$version
      runHook postUnpack
    '';

    dontConfigure = true;

    buildPhase =
      # Configure the Nim compiler to use $CC and $CXX as backends
      # The compiler is configured by two configuration files, each with
      # a different DSL. The order of evaluation matters and that order
      # is not documented, so duplicate the configuration across both files.
      ''
        runHook preBuild
        cat >> config/config.nims << WTF

        switch("os", "${nimTarget.os}")
        switch("cpu", "${nimTarget.cpu}")
        switch("define", "nixbuild")

        # Configure the compiler using the $CC set by Nix at build time
        import strutils
        let cc = getEnv"CC"
        if cc.contains("gcc"):
          switch("cc", "gcc")
        elif cc.contains("clang"):
          switch("cc", "clang")
        WTF

        mv config/nim.cfg config/nim.cfg.old
        cat > config/nim.cfg << WTF
        os = "${nimTarget.os}"
        cpu =  "${nimTarget.cpu}"
        define:"nixbuild"
        WTF

        cat >> config/nim.cfg < config/nim.cfg.old
        rm config/nim.cfg.old

        cat >> config/nim.cfg << WTF

        clang.cpp.exe %= "\$CXX"
        clang.cpp.linkerexe %= "\$CXX"
        clang.exe %= "\$CC"
        clang.linkerexe %= "\$CC"
        gcc.cpp.exe %= "\$CXX"
        gcc.cpp.linkerexe %= "\$CXX"
        gcc.exe %= "\$CC"
        gcc.linkerexe %= "\$CC"
        WTF

        runHook postBuild
      '';

    wrapperArgs = [
      "--prefix PATH : ${lib.makeBinPath [ buildPackages.gdb ]}:${
        placeholder "out"
      }/bin"
      # Used by nim-gdb

      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl pcre ]}"
      # These libraries may be referred to by the standard library.
      # This is broken for cross-compilation because the package
      # set will be shifted back by nativeBuildInputs.

      "--set NIM_CONFIG_PATH ${placeholder "out"}/etc/nim"
      # Use the custom configuration

      ''--set NIX_HARDENING_ENABLE "''${NIX_HARDENING_ENABLE/fortify}"''
      # Fortify hardening appends -O2 to gcc flags which is unwanted for unoptimized nim builds.
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/etc

      cp -r config $out/etc/nim

      for binpath in ${nim'}/bin/nim?*; do
        local binname=`basename $binpath`
        makeWrapper \
          $binpath $out/bin/${targetPlatform.config}-$binname \
          $wrapperArgs
        ln -s $out/bin/${targetPlatform.config}-$binname $out/bin/$binname
      done

      makeWrapper \
        ${nim'}/nim/bin/nim $out/bin/${targetPlatform.config}-nim \
        $wrapperArgs
      ln -s $out/bin/${targetPlatform.config}-nim $out/bin/nim

      makeWrapper \
        ${nim'}/bin/testament $out/bin/${targetPlatform.config}-testament \
        $wrapperArgs
      ln -s $out/bin/${targetPlatform.config}-testament $out/bin/testament

      makeWrapper \
        ${nimble'}/bin/nimble $out/bin/${targetPlatform.config}-nimble \
        --suffix PATH : $out/bin
      ln -s $out/bin/${targetPlatform.config}-nimble $out/bin/nimble

      runHook postInstall
    '';

    passthru = {
      nim = nim';
      nimble = nimble';
    };

    meta = nim'.meta // {
      description = nim'.meta.description
        + " (${targetPlatform.config} wrapper)";
      platforms = with lib.platforms; unix ++ genode;
    };
  };

}
