{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-raCI9z9+GjvwhSBugeD4PticHQsjp4ns0LoKJQckrug=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner', " ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pyyaml
  ];

  # Tests require git lfs download of repository
  doCheck = false;

  # pythonImportsCheck does not work
  # TypeError: load() missing 1 required positional argument: 'Loader'

  meta = {
    description = "Srim Automation of Tasks via Python";
    homepage = "https://gitlab.com/costrouc/pysrim";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
