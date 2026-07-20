{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,

  # dependencies
  attrs,
  babel,
  fluent-syntax,
  pytz,
  typing-extensions,
}:

let
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "fluent.runtime@${version}";
    hash = "sha256-Crg6ybweOZ4B3WfLMOcD7+TxGEZPTHJUxr8ItLB4G+Y=";
  };
in
buildPythonPackage {
  pname = "fluent-runtime";
  inherit version;
  pyproject = true;

  inherit src;
  sourceRoot = "${src.name}/fluent.runtime";

  build-system = [ setuptools ];

  dependencies = [
    attrs
    babel
    fluent-syntax
    pytz
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/projectfluent/python-fluent/pull/203
    "test_timeZone"
  ];

  pythonImportsCheck = [ "fluent.runtime" ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/${src.rev}/fluent.runtime/CHANGELOG.rst";
    description = "Localization library for expressive translations";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/${src.rev}";
    homepage = "https://projectfluent.org/python-fluent/fluent.runtime/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
