{
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  lib,
  nix-update-script,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  setuptools,
  typing-extensions,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "j2lint";
  version = "1.3.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "j2lint";
    rev = "v${version}";
    hash = "sha256-aT25Yq5GkQpZBgVNjYdV/afyqFanJkmqkDGMz2Yf+Ps=";
  };

  build-system = [ setuptools ];
  dependencies = [
    jinja2
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/aristanetworks/j2lint";
    description = "Jinja2 Linter CLI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
