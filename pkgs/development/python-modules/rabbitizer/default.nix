{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "rabbitizer";
  version = "1.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OiII8St7oL1b/4eagZFEWLNGQ/qvGM21j+hGfK4l9/c=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  meta = {
    description = "MIPS instruction decoder";
    homepage = "https://pypi.org/project/rabbitizer/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qubitnano ];
  };
}
