{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
}:

buildPythonPackage rec {
  pname = "colorthief";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fengsp";
    repo = "color-thief-py";
    rev = version;
    sha256 = "0lzpflal1iqbj4k7hayss5z024qf2sn8c3wxw03a0mgxg06ca2hm";
  };

  propagatedBuildInputs = [ pillow ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "colorthief" ];

  meta = with lib; {
    description = "Python module for grabbing the color palette from an image";
    homepage = "https://github.com/fengsp/color-thief-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
