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
  version = "7.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ndlpRUgn4Sfb2TaWsgdHI55tVA4IKTfJDxSslbMPWEU=";
  };

  propagatedBuildInputs = [ six pillow pymaging_png setuptools ];
  nativeCheckInputs = [ mock ];

  meta = with lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
