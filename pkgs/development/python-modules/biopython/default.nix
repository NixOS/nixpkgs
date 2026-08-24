{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "biopython";
  version = "1.88";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mqoxwL2k0Fn3su4Av9tcu3Ot4wV6pLc3p8wBhwkdBxo=";
  };

  patches = [
    # Numpy 2.4 compatibility
    (fetchpatch {
      url = "https://github.com/biopython/biopython/pull/5161.patch";
      hash = "sha256-oN0nNlhvshIgNrmm+tIeCAJx1U/OqhdL4tj51DV2CHU=";
    })
  ];

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
