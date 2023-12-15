{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annotated-types";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "annotated-types";
    repo = "annotated-types";
    rev = "refs/tags/v${version}";
    hash = "sha256-SZ9/rXYcns4DFM6vk6SRKvuv3MY3T7xO9aW7WAQqtVE=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  pythonImportsCheck = [ "annotated_types" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Reusable constraint types to use with typing.Annotated";
    homepage = "https://github.com/annotated-types/annotated-types";
    changelog = "https://github.com/annotated-types/annotated-types/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
