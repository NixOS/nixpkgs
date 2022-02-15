{ lib
, stdenv
, callPackage
, python27Packages
, installShellFiles
, rSrc
, version
, oildev
, binlore
}:

python27Packages.buildPythonApplication {
  pname = "resholve";
  inherit version;
  src = rSrc;
  format = "other";
  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    oildev
    /*
    Disable configargparse's tests on aarch64-darwin.
    Several of py27 scandir's tests fail on aarch64-darwin. Chain:
    configargparse -> pytest-check-hook -> pytest -> pathlib2 -> scandir
    TODO: drop if https://github.com/NixOS/nixpkgs/issues/156807 resolves?
    */
    (python27Packages.configargparse.overridePythonAttrs (old: {
      doCheck = stdenv.hostPlatform.system != "aarch64-darwin";
    }))
  ];

  patchPhase = ''
    for file in resholve; do
      substituteInPlace $file --subst-var-by version ${version}
    done
  '';

  installPhase = ''
    install -Dm755 resholve $out/bin/resholve
    installManPage resholve.1
  '';

  # Do not propagate Python; may be obsoleted by nixos/nixpkgs#102613
  # for context on why, see abathur/resholve#20
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  passthru.tests = callPackage ./test.nix { inherit rSrc; inherit binlore; };

  meta = with lib; {
    description = "Resolve external shell-script dependencies";
    homepage = "https://github.com/abathur/resholve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
