{ lib
, appdirs
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nmapthon2";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6mGMB8nW6CqTPxgc1fveh6fJo/t+jpUS6rJ2VR2gU/g=";
  };

  # Tests are not part of the PyPI source and source is not tagged
  # https://github.com/cblopez/nmapthon2/issues/3
  doCheck = false;

  pythonImportsCheck = [
    "nmapthon2"
  ];

  meta = with lib; {
    description = "Python library to automate nmap";
    homepage = "https://github.com/cblopez/nmapthon2";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
