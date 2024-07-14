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
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mo94nRhuO9dogtV7Wq0/oIx4cKhWzIO8262fSu+9qU0=";
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
