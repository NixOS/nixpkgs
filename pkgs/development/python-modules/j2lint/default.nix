{
  lib,
  buildPythonPackage,
  jinja2,
  setuptools,
  fetchFromGitHub,
  rich,
  versionCheckHook,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "j2lint";
  version = "1.2.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "j2lint";
    rev = "v${version}";
    hash = "sha256-/3hd2RnyxX4CsqWvsmGB/5QoeQIsFhtG3nntHer0or8=";
  };

  build-system = [ setuptools ];
  dependencies = [
    jinja2
    rich
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = with lib; {
    homepage = "https://github.com/aristanetworks/j2lint";
    description = "Jinja2 Linter CLI";
    license = licenses.mit;
    maintainers = with maintainers; [ polyfloyd ];
  };
}
