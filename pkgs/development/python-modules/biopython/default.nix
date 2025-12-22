{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "biopython";
  version = "1.86";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k6ULWGpNLOxoqy+Z0D71g8V2HY+6VTXLjoHaeB0Nkv8=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "Bio" ];

  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    cd Tests
    python run_tests.py --offline

    runHook postCheck
  '';

  meta = {
    description = "Python library for bioinformatics";
    longDescription = ''
      Biopython is a set of freely available tools for biological computation
      written in Python by an international team of developers. It is a
      distributed collaborative effort to develop Python libraries and
      applications which address the needs of current and future work in
      bioinformatics.
    '';
    homepage = "https://biopython.org/wiki/Documentation";
    maintainers = with lib.maintainers; [ luispedro ];
    license = lib.licenses.bsd3;
  };
}
