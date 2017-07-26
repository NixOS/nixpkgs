{ lib , buildPythonPackage , fetchPypi, tkinter }:

buildPythonPackage rec {
  pname = "Pmw";
  version = "2.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "080iml3868nxniyn56kcwnbghm10j7fw74a5nj0s19sm4zsji78b";
  };

  propagatedBuildInputs = [ tkinter ];

  # Disable tests due to their xserver requirement
  doCheck = false;

  meta = {
    description = "A toolkit for building high-level compound widgets in Python using the Tkinter module";
    homepage = "http://pmw.sourceforge.net/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mounium ];
  };
}
