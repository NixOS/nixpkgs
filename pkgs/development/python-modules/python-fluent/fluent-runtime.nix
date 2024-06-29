{ buildPythonPackage
, fetchFromGitHub
, lib
, setuptools

, # dependencies
  attrs
, babel
, fluent-syntax
, pytz
, typing-extensions
}:

let
  version = "0.4.0";
  tag = "fluent.runtime@${version}";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = tag;
    hash = "sha256-Crg6ybweOZ4B3WfLMOcD7+TxGEZPTHJUxr8ItLB4G+Y=";
  };
in
buildPythonPackage {
  pname = "fluent-runtime";
  inherit version;
  format = "setuptools";

  inherit src;
  sourceRoot = "${src.name}/fluent.runtime";

  dependencies = [
    attrs
    babel
    fluent-syntax
    pytz
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [
    "fluent.runtime"
  ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/${tag}/fluent.runtime/CHANGELOG.rst";
    description = "Localization library for expressive translations";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/${tag}";
    homepage = "https://projectfluent.org/python-fluent/fluent.runtime/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
