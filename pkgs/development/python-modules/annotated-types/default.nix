{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typing-extensions,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "annotated-types";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "annotated-types";
    repo = "annotated-types";
    rev = "refs/tags/v${version}";
    hash = "sha256-I1SPUKq2WIwEX5JmS3HrJvrpNrKDu30RWkBRDFE+k9A=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [ typing-extensions ];

  pythonImportsCheck = [ "annotated_types" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Reusable constraint types to use with typing.Annotated";
    homepage = "https://github.com/annotated-types/annotated-types";
    changelog = "https://github.com/annotated-types/annotated-types/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
