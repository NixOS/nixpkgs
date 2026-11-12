{
  lib,
  buildPythonPackage,
  fetchPypi,
  defcon,
  fontmath,
  setuptools,
  unicodedata2,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutatormath";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "MutatorMath";
    inherit (finalAttrs) version;
    hash = "sha256-gSfB/60WRvEalTdSKWxD9diMvVKT//A/CT2RawvBOGQ=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    fontmath
    unicodedata2
    defcon
  ];

  checkPhase = ''
    runHook preCheck

    python Lib/mutatorMath/test/run.py

    runHook postCheck
  '';

  meta = {
    description = "Piecewise linear interpolation in multiple dimensions with multiple, arbitrarily placed, masters";
    homepage = "https://github.com/LettError/MutatorMath";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
