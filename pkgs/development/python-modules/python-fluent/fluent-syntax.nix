{ buildPythonPackage, fetchFromGitHub, lib, setuptools, typing-extensions }:

let
  version = "0.19.0";
  tag = "fluent.syntax@${version}";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = tag;
    hash = "sha256-nULngwBG/ebICRDi6HMHBdT+r/oq6tbDL7C1iMZpMsA=";
  };
in
buildPythonPackage {
  pname = "fluent-syntax";
  inherit version;
  format = "setuptools";

  inherit src;
  sourceRoot = "${src.name}/fluent.syntax";

  dependencies = [
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [
    "fluent.syntax"
  ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/${tag}/fluent.syntax/CHANGELOG.md";
    description = "Parse, analyze, process, and serialize Fluent files";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/${tag}";
    homepage = "https://projectfluent.org/python-fluent/fluent.syntax/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
