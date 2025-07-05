{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,
  pillow,
  jinja2,
  unidecode,
}:
buildPythonPackage rec {
  pname = "plasTeX";
  version = "3.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "plastex";
    owner = "plastex";
    tag = version;
    hash = "sha256-Muuin7n0aPOZwlUaB32pONy5eyIjtPNb4On5gC9wOcQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    typing-extensions
    pillow
    jinja2
    unidecode
  ];

  meta = {
    description = "plasTeX is a Python package to convert LaTeX markup to DOM";
    homepage = "https://plastex.github.io/plastex/";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
