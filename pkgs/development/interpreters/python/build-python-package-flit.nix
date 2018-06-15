# This function provides specific bits for building a flit-based Python package.

{ python
, flit
}:

{ ... } @ attrs:

attrs // {
  buildInputs = [ flit ];
  buildPhase = attrs.buildPhase or ''
    runHook preBuild
    flit build --format wheel
    runHook postBuild
  '';

  # Flit packages, like setuptools packages, might have tests.
  installCheckPhase = attrs.checkPhase or ''
    ${python.interpreter} -m unittest discover
  '';
  doCheck = attrs.doCheck or true;
}
