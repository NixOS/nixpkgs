{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  pycryptodome,
  reportlab,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdfrw2";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5qnMq4Pnaaeov+Lb3fD0ndfr5SAy6SlXTwG7v6IZce0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pillow
    reportlab
    pycryptodome
  ];

  pythonImportCheck = [ "pdfrw" ];

  meta = with lib; {
    description = "Pure Python library that reads and writes PDFs";
    homepage = "https://github.com/sarnold/pdfrw";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.mit;
  };
}
