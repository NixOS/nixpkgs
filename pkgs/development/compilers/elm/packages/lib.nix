{ writeScriptBin, stdenv, lib, elm }:
let
  patchBinwrap =
    let
      # Patching binwrap by NoOp script
      binwrap = writeScriptBin "binwrap" ''
        #! ${stdenv.shell}
        echo "binwrap called: Returning 0"
        return 0
      '';
      binwrap-install = writeScriptBin "binwrap-install" ''
        #! ${stdenv.shell}
        echo "binwrap-install called: Doing nothing"
      '';
    in targets: pkg:
      pkg.override (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ binwrap binwrap-install ];

        # Manually install targets
        # by symlinking binaries into `node_modules`
        postInstall = let
          binFile = module: lib.strings.removeSuffix ("-" + module.version) module.name;
        in (old.postInstall or "") + ''
          ${lib.concatStrings (map (module: ''
              echo "linking ${binFile module}"
              ln -sf ${module}/bin/${binFile module} \
                  node_modules/${binFile module}/bin/${binFile module}
          '') targets)}
        '';
      });

  patchNpmElm = pkg:
    pkg.override (old: {
      preRebuild = (old.preRebuild or "") + ''
        rm node_modules/elm/install.js
        echo "console.log('Nixpkgs\' version of Elm will be used');" > node_modules/elm/install.js
      '';
      postInstall = (old.postInstall or "") + ''
        ln -sf ${elm}/bin/elm node_modules/elm/bin/elm
      '';
    });
in
{ inherit patchBinwrap patchNpmElm; }
