{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9k1lpx5pb9idMwgYAZjVEM915w5wsmLWQ/tnHNSKHAs=";
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
