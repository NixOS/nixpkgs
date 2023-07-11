{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FhYNQ6ODLJSdXRzEwmE5CLxzeImBKj6brx2CBeVC7BM=";
  };

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [
    "msgspec"
  ];

  meta = with lib; {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    changelog = "https://github.com/jcrist/msgspec/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
