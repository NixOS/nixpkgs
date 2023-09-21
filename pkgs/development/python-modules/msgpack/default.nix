{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, cython_3
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-x2/upux5CnHBoP0OjN6ffSJxOAhqDs+zWx0MeXVn8XA=";
  };

  nativeBuildInputs = [
    setuptools
    cython_3
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
