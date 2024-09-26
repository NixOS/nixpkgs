{
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "install_freedesktop";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PlqbNAQXW2nDE7ayjGuiHsgKK0q9lkr4ak3kPDChlfA=";
  };

  build-system = [
    setuptools-scm
  ];

  doCheck = false;
}
