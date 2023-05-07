# https://nim-lang.github.io/Nim/packaging.html
# https://nim-lang.org/docs/nimc.html

{ lib, callPackage, buildPackages, stdenv, fetchurl, fetchgit, fetchFromGitHub
, makeWrapper, openssl, pcre, readline, boehmgc, sqlite, nim-unwrapped
, nimble-unwrapped, Security }:

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
    else if isPower && is32bit then
      "powerpc"
    else if isPower && is64bit then
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

  bootstrapCompiler = stdenv.mkDerivation {
    pname = "nim-bootstrap";
    inherit (nim-unwrapped) version src preBuild;
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
    version = "1.6.12";
    strictDeps = true;

    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${version}.tar.xz";
      hash = "sha256-rO8LCrdzYE1Nc5S2hRntt0+zD0aRIpSyi8J+DHtLTcI=";
    };

    buildInputs = [ boehmgc openssl pcre readline sqlite ]
      ++ lib.optional stdenv.isDarwin Security;

    patches = [
      ./NIM_CONFIG_DIR.patch
      # Override compiler configuration via an environmental variable

      ./nixbuild.patch
      # Load libraries at runtime by absolute path
    ] ++ lib.optional (!stdenv.hostPlatform.isWindows) ./toLocation.patch;

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

    preBuild = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
      substituteInPlace makefile \
        --replace "aarch64" "arm64"
    '';

    buildPhase = ''
      runHook preBuild
      local HOME=$TMPDIR
      ./bin/nim c --parallelBuild:$NIX_BUILD_CORES koch
      ./koch boot $kochArgs --parallelBuild:$NIX_BUILD_CORES
      ./koch toolsNoExternal $kochArgs --parallelBuild:$NIX_BUILD_CORES
      ./bin/nim js -d:release tools/dochack/dochack.nim
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dt $out/bin bin/*
      ln -sf $out/nim/bin/nim $out/bin/nim
      ln -sf $out/nim/lib $out/lib
      ./install.sh $out
      cp -a tools $out/nim/
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
    version = "0.14.2";
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v${version}";
      hash = "sha256-8b5yKvEl7c7wA/8cpdaN2CSvawQJzuRce6mULj3z/mI=";
    };

    depsBuildBuild = [ nim-unwrapped ];
    buildInputs = [ openssl ]
      ++ lib.optional stdenv.isDarwin Security;

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

    meta = with lib; {
      description = "Package manager for the Nim programming language";
      homepage = "https://github.com/nim-lang/nimble";
      license = licenses.bsd3;
      maintainers = with maintainers; [ ehmry ];
      mainProgram = "nimble";
    };
  };

  nim = let
    nim' = buildPackages.nim-unwrapped;
    nimble' = buildPackages.nimble-unwrapped;
    inherit (stdenv) targetPlatform;
    self = stdenv.mkDerivation {
      name = "${targetPlatform.config}-nim-wrapper-${nim'.version}";
      inherit (nim') version;
      preferLocalBuild = true;
      strictDeps = true;

      nativeBuildInputs = [ makeWrapper ];

      # Needed for any nim package that uses the standard library's
      # 'std/sysrand' module.
      depsTargetTargetPropagated = lib.optional stdenv.isDarwin Security;

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

      wrapperArgs = lib.optionals (!(stdenv.isDarwin && stdenv.isAarch64)) [
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
          --set-default CC $(command -v $CC) \
          --set-default CXX $(command -v $CXX) \
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
  in self // {
    pkgs = callPackage ../../../top-level/nim-packages.nix { nim = self; };
  };

}
