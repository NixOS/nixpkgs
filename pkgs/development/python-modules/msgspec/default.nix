{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = pname;
    rev = version;
    hash = "sha256-q7WNVnkvK7MTleHEuClOFJ0Wv6EWu/3ztMi6TYdKgKU=";
  };

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [
    "msgspec"
  ];

  meta = with lib; {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
