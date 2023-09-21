{ lib, fetchPypi, buildPythonPackage, lzo, nose }:

buildPythonPackage rec {
  pname = "python-lzo";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83cbd8ecaae284735250e31d6c0ecc18ac08763fab2a8c910dc5a6910db6250c";
  };

  buildInputs = [ lzo ];
  propagatedBuildInputs = [ ];
  nativeCheckInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/jd-boyd/python-lzo";
    description = "Python bindings for the LZO data compression library";
    license = licenses.gpl2;
    maintainers = [ maintainers.jbedo ];
  };
}
