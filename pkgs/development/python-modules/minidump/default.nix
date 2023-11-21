{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.22";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PPvvvHz3WA67Vn2P7MIY+ChkjXrCOuTgj0KXr4B2mZ0=";
  };

  # Upstream doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "minidump"
  ];

  meta = with lib; {
    description = "Python library to parse and read Microsoft minidump file format";
    homepage = "https://github.com/skelsec/minidump";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
