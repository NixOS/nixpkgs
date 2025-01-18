{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.3";

  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pybcj";
    rev = "v${version}";
    hash = "sha256-ExSt7E7ZaVEa0NwAQHU0fOaXJW9jYmEUUy/1iUilGz8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = {
    homepage = "https://codeberg.org/miurahr/pybcj";
    description = "BCJ (Branch-Call-Jump) filter for Python";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
