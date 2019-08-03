# This function provides generic bits to install a Python wheel.

{ python
}:

{ buildInputs ? []
# Additional flags to pass to "pip install".
, installFlags ? []
, ... } @ attrs:

attrs // {
  buildInputs = buildInputs ++ [ python.pythonForBuild.pkgs.bootstrapped-pip ];

  configurePhase = attrs.configurePhase or ''
    runHook preConfigure
    runHook postConfigure
  '';

  installPhase = attrs.installPhase or ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    pushd dist
    ${python.pythonForBuild.pkgs.bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache ${toString installFlags} --build tmpbuild
    popd

    runHook postInstall
  '';
}
