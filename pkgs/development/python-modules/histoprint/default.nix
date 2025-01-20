{
  lib,
  fetchPypi,
  buildPythonPackage,
  click,
  numpy,
  setuptools,
  setuptools-scm,
  uhi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "histoprint";
  version = "2.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4d9yk1BFW0V+l/IIg1N650Uih558M8YJ3xLyR8ykoh0=";
  };

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    numpy
    uhi
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pretty print histograms to the console";
    mainProgram = "histoprint";
    homepage = "https://github.com/scikit-hep/histoprint";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
