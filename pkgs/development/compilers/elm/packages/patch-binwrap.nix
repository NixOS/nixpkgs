{ writeScriptBin, stdenv, lib }:
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
in
targets:
pkg:
pkg.override {
  nativeBuildInputs = pkg.nativeBuildInputs ++ [ binwrap binwrap-install ];

  # Manually install targets
  # by symlinking binaries into `node_modules`
  postInstall = let
    binFile = module: lib.strings.removeSuffix ("-" + module.version) module.name;
  in ''
    ${lib.concatStrings (map (module: ''
        echo "linking ${binFile module}"
        ln -sf ${module}/bin/${binFile module} \
            node_modules/${binFile module}/bin/${binFile module}
    '') targets)}
  '';
}
