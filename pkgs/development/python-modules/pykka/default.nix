{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jodal";
    repo = "pykka";
    tag = "v${version}";
    hash = "sha256-xCvWqWThsi78S9DW4ssz0gezb0RFGlqW2W8oMxkNc+E=";
  };

  build-system = [ hatchling ];

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
