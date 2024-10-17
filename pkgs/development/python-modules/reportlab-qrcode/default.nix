{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  qrcode,
  reportlab,
  pillow,
  pytest,
  pyzbar,
}:

buildPythonPackage rec {
  pname = "reportlab-qrcode";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m/oeuA797MEBOJBIG157VIa7TbEbRRVK/O8Arz/oO/o=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    qrcode
    reportlab
  ];

  optional-dependencies = {
    testing = [
      pillow
      pytest
      pyzbar
    ];
  };

  pythonImportsCheck = [ "reportlab_qrcode" ];

  meta = with lib; {
    description = "Allows to create QR codes for use with the ReportLab PDF library";
    homepage = "https://pypi.org/project/reportlab-qrcode/";
    license = licenses.mit;
    maintainers = with maintainers; [ xanderio ];
  };
}
