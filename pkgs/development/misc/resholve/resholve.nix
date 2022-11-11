{ lib
, stdenv
, callPackage
, python27Packages
, installShellFiles
, rSrc
, version
, oildev
, binlore
, resholve-utils
}:

python27Packages.buildPythonApplication {
  pname = "resholve";
  inherit version;
  src = rSrc;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    oildev
    python27Packages.configargparse
  ];

  postPatch = ''
    for file in setup.cfg _resholve/version.py; do
      substituteInPlace $file --subst-var-by version ${version}
    done
  '';

  postInstall = ''
    installManPage resholve.1
  '';

  # Do not propagate Python; may be obsoleted by nixos/nixpkgs#102613
  # for context on why, see abathur/resholve#20
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  passthru = {
    inherit (resholve-utils) mkDerivation phraseSolution writeScript writeScriptBin;
    tests = callPackage ./test.nix { inherit rSrc binlore; };
  };

  meta = with lib; {
    description = "Resolve external shell-script dependencies";
    homepage = "https://github.com/abathur/resholve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
