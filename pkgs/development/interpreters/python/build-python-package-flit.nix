# This function provides specific bits for building a flit-based Python package.

{ flit
}:

{ ... } @ attrs:

attrs // {
  buildInputs = [ flit ];
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    flit wheel
    runHook postBuild
  '';

  # Flit packages do not come with tests.
  installCheckPhase = attrs.checkPhase or ":";
  doCheck = attrs.doCheck or false;
}