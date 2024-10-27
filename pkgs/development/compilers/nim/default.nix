# https://nim-lang.github.io/Nim/packaging.html
# https://nim-lang.org/docs/nimc.html

{ lib, callPackage, buildPackages, stdenv, fetchurl, fetchgit
, makeWrapper, openssl, pcre, readline, boehmgc, sqlite, Security
, nim-unwrapped-2, nim-unwrapped-1 }:

let
  inherit (nim-unwrapped-2.passthru) nimHost nimTarget;
in {

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

  nim1 = wrapNim {
    nim' = buildPackages.nim-unwrapped-1;
    patches = [ ./nim.cfg.patch ];
  };

})
