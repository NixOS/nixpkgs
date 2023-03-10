{ lib
, buildPythonPackage
, fetchPypi
, six
, pillow
, pymaging_png
, mock
, setuptools
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "7.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "375a6ff240ca9bd41adc070428b5dfc1dcfbb0f2507f1ac848f6cded38956578";
  };

  propagatedBuildInputs = [ six pillow pymaging_png setuptools ];
  nativeCheckInputs = [ mock ];

  meta = with lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
