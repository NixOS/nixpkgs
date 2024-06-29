{ buildPythonPackage, fetchFromGitHub, fluent-syntax, lib, pygments, setuptools }:

let
  version = "1.0";
  tag = "fluent.pygments@${version}";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = tag;
    hash = "sha256-AR2uce3HS1ELzpoHmx7F/5/nrL+7KhYemw/00nmvLik=";
  };
in
buildPythonPackage {
  pname = "fluent-pygments";
  inherit version;
  format = "setuptools";

  inherit src;
  sourceRoot = "${src.name}/fluent.pygments";

  dependencies = [
    fluent-syntax
    pygments
    setuptools
  ];

  pythonImportsCheck = [
    "fluent.pygments"
  ];

  meta = {
    changelog = "https://github.com/projectfluent/python-fluent/blob/main/fluent.pygments/CHANGELOG.rst";
    description = "Plugin for pygments to add syntax highlighting of Fluent files in Sphinx";
    homepage = "https://projectfluent.org/python-fluent/fluent.pygments/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getpsyched ];
  };
}
