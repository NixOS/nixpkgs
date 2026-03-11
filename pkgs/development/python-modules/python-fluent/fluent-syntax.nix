{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

let
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "fluent.syntax@${version}";
    hash = "sha256-nULngwBG/ebICRDi6HMHBdT+r/oq6tbDL7C1iMZpMsA=";
  };
in
buildPythonPackage {
  pname = "fluent-syntax";
  inherit version;
  pyproject = true;

  inherit src;
  sourceRoot = "${src.name}/fluent.syntax";

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fluent.syntax" ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/${src.rev}/fluent.syntax/CHANGELOG.md";
    description = "Parse, analyze, process, and serialize Fluent files";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/${src.rev}";
    homepage = "https://projectfluent.org/python-fluent/fluent.syntax/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
