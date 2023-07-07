{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-raCI9z9+GjvwhSBugeD4PticHQsjp4ns0LoKJQckrug=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  propagatedBuildInputs = [
    numpy
    pyyaml
  ];

  # Tests require git lfs download of repository
  doCheck = false;

  # pythonImportsCheck does not work
  # TypeError: load() missing 1 required positional argument: 'Loader'

  meta = with lib; {
    description = "Srim Automation of Tasks via Python";
    homepage = "https://gitlab.com/costrouc/pysrim";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
