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
  version = "7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d72861b65e26b611609f0547f0febe58aed8ae229d6bf4e675834f40742915b3";
  };

  propagatedBuildInputs = [ six pillow pymaging_png setuptools ];
  checkInputs = [ mock ];

  meta = with lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
