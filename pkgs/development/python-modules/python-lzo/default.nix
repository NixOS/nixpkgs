{ lib, fetchPypi, buildPythonPackage, lzo, nose }:

buildPythonPackage rec {
  pname = "python-lzo";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iakqgd51n1cd7r3lpdylm2rgbmd16y74cra9kcapwg84mlf9a4p";
  };

  buildInputs = [ lzo ];
  propagatedBuildInputs = [ ];
  checkInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/jd-boyd/python-lzo";
    description = "Python bindings for the LZO data compression library";
    license = licenses.gpl2;
    maintainers = [ maintainers.jbedo ];
  };
}
