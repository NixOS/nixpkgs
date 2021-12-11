{ lib
, buildPythonPackage
, colorlog
, pyyaml
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "lupupy";
  version = "0.0.22";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3yxhuG5aYC6Vx04pJtKxpUKevvw9hyZ9zVi6XmLRIv8=";
  };

  propagatedBuildInputs = [
    colorlog
    pyyaml
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lupupy"
  ];

  meta = with lib; {
    description = "Python module to control Lupusec alarm control panels";
    homepage = "https://github.com/majuss/lupupy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
