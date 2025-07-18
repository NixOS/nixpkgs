{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pytest-mock,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = "pykka";
    tag = "v${version}";
    hash = "sha256-n9TgXcmUEIQdqtrY+9T+EtPys+7OzXCemRwNPj1xPDw=";
  };

  build-system = [ poetry-core ];

  dependencies = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "pykka" ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/releases/tag/${src.tag}";
    maintainers = [ ];
    license = licenses.asl20;
  };
}
