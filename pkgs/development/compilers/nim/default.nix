# https://nim-lang.github.io/Nim/packaging.html
# https://nim-lang.org/docs/nimc.html

{ lib, callPackage, buildPackages, stdenv, fetchurl, fetchgit
, makeWrapper, openssl, pcre, readline, boehmgc, sqlite, Security
, nim-unwrapped-2, nim-unwrapped-1, nim }:

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

in {

  nim-unwrapped-2 = stdenv.mkDerivation (finalAttrs: {
    pname = "nim-unwrapped";
    version = "2.0.8";
    strictDeps = true;

    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
      hash = "sha256-VwLahEcA0xKdtzFwtcYGrb37h+grgWwNkRB+ogpl3xY=";
    };

    buildInputs = [ boehmgc openssl pcre readline sqlite ]
      ++ lib.optional stdenv.hostPlatform.isDarwin Security;

    patches = [
      ./NIM_CONFIG_DIR.patch
      # Override compiler configuration via an environmental variable

      ./nixbuild.patch
      # Load libraries at runtime by absolute path

      ./extra-mangling.patch
      # Mangle store paths of modules to prevent runtime dependence.

      ./openssl.patch
      # dlopen is widely used by Python, Ruby, Perl, ... what you're really telling me here is that your OS is fundamentally broken. That might be news for you, but it isn't for me.
    ];

    configurePhase = let
      bootstrapCompiler = stdenv.mkDerivation {
        pname = "nim-bootstrap";
        inherit (finalAttrs) version src preBuild;
        enableParallelBuilding = true;
        installPhase = ''
          runHook preInstall
          install -Dt $out/bin bin/nim
          runHook postInstall
        '';
      };
    in ''
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
    ] ++ lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) "-d:nativeStacktrace";

    preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
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
      cp -a tools dist $out/nim/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Statically typed, imperative programming language";
      homepage = "https://nim-lang.org/";
      license = licenses.mit;
      mainProgram = "nim";
      maintainers = with maintainers; [ ehmry ];
    };
  });

  nim-unwrapped-1 = nim-unwrapped-2.overrideAttrs (finalAttrs: prevAttrs: {
    version = "1.6.20";
    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
      hash = "sha256-/+0EdQTR/K9hDw3Xzz4Ce+kaKSsMnFEWFQTC87mE/7k=";
    };

    patches = [
      ./NIM_CONFIG_DIR.patch
      # Override compiler configuration via an environmental variable

      ./nixbuild.patch
      # Load libraries at runtime by absolute path

      ./extra-mangling.patch
      # Mangle store paths of modules to prevent runtime dependence.
    ] ++ lib.optional (!stdenv.hostPlatform.isWindows) ./toLocation.patch;
  });

} // (let
  wrapNim = { nim', patches }:
    let targetPlatformConfig = stdenv.targetPlatform.config;
    in stdenv.mkDerivation (finalAttrs: {
        name = "${targetPlatformConfig}-nim-wrapper-${nim'.version}";
        inherit (nim') version;
        preferLocalBuild = true;
        strictDeps = true;

        nativeBuildInputs = [ makeWrapper ];

        # Needed for any nim package that uses the standard library's
        # 'std/sysrand' module.
        depsTargetTargetPropagated = lib.optional stdenv.hostPlatform.isDarwin Security;

        inherit patches;

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

        wrapperArgs = lib.optionals (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) [
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
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/etc

          cp -r config $out/etc/nim

          for binpath in ${nim'}/bin/nim?*; do
            local binname=`basename $binpath`
            makeWrapper \
              $binpath $out/bin/${targetPlatformConfig}-$binname \
              $wrapperArgs
            ln -s $out/bin/${targetPlatformConfig}-$binname $out/bin/$binname
          done

          makeWrapper \
            ${nim'}/nim/bin/nim $out/bin/${targetPlatformConfig}-nim \
            --set-default CC $(command -v $CC) \
            --set-default CXX $(command -v $CXX) \
            $wrapperArgs
          ln -s $out/bin/${targetPlatformConfig}-nim $out/bin/nim

          makeWrapper \
            ${nim'}/bin/testament $out/bin/${targetPlatformConfig}-testament \
            $wrapperArgs
          ln -s $out/bin/${targetPlatformConfig}-testament $out/bin/testament

        '' + ''
          runHook postInstall
        '';

        passthru = { nim = nim'; };

        meta = nim'.meta // {
          description = nim'.meta.description
            + " (${targetPlatformConfig} wrapper)";
          platforms = with lib.platforms; unix ++ genode ++ windows;
        };
      });
in {

  nim2 = wrapNim {
    nim' = buildPackages.nim-unwrapped-2;
    patches = [ ./nim2.cfg.patch ];
  };

  nim1 = wrapNim {
    nim' = buildPackages.nim-unwrapped-1;
    patches = [ ./nim.cfg.patch ];
  };

})
