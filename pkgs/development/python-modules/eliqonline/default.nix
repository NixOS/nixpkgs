{ lib
, aiohttp
, buildPythonPackage
, docopt
, fetchFromGitHub
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "eliqonline";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
     owner = "molobrakos";
     repo = "eliqonline";
     rev = "v1.2.2";
     sha256 = "17grl8nkrf7mhn3rz4zr78k387vjiyhg1nbhgb62ba59fx001qcp";
  };

  propagatedBuildInputs = [
    aiohttp
    docopt
    pyyaml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "eliqonline"
  ];

  meta = with lib; {
    description = "Python client to the Eliq Online API";
    homepage = "https://github.com/molobrakos/eliqonline";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
