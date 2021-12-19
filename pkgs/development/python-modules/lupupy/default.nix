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
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d606233ebb9c25f5f5aa2fc93e47621a61748d9dce08c605a0533c8957190a9";
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
