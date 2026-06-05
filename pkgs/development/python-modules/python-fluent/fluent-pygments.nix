{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,

  # dependencies
  fluent-syntax,
  pygments,
  six,
}:

let
  version = "1.0";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "fluent.pygments@${version}";
    hash = "sha256-AR2uce3HS1ELzpoHmx7F/5/nrL+7KhYemw/00nmvLik=";
  };
in
buildPythonPackage {
  pname = "fluent-pygments";
  inherit version;
  pyproject = true;

  inherit src;
  sourceRoot = "${src.name}/fluent.pygments";

  build-system = [ setuptools ];

  dependencies = [
    fluent-syntax
    pygments
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fluent.pygments" ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/main/fluent.pygments/CHANGELOG.rst";
    description = "Plugin for pygments to add syntax highlighting of Fluent files in Sphinx";
    homepage = "https://projectfluent.org/python-fluent/fluent.pygments/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
