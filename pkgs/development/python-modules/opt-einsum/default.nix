{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "opt-einsum";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "opt_einsum";
    inherit version;
    hash = "sha256-WfZHX3e7w33PfNdIUZwOxgci6R5jyhFOaIIcDFSkZUk=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "opt_einsum"
  ];

  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support";
    homepage = "https://github.com/dgasmith/opt_einsum";
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
