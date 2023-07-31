{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wHVUQoTq3Fzdxw9HVzMdmdy8FrK71ISdFfiq5M820xw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "msgpack"
  ];

  meta = with lib;  {
    description = "MessagePack serializer implementation";
    homepage = "https://github.com/msgpack/msgpack-python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/v${version}/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
