{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = pname;
    rev = version;
    hash = "sha256-8guKmEnDAOVzBuSvqy5V+dWY1f8FPbysMZTe9FVJPxQ=";
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
