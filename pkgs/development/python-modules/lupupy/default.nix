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
  version = "0.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SxhGUwcZjaRNCS5dB2hh5uctFGHWuKnM48CcIz6VMh8=";
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
    changelog = "https://github.com/majuss/lupupy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
