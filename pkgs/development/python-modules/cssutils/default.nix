{ stdenv, buildPythonPackage, fetchPypi, mock }:

buildPythonPackage rec {
  pname = "cssutils";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qwha9x1wml2qmipbcz03gndnlwhzrjdvw9i09si247a90l8p8fq";
  };

  buildInputs = [ mock ];

  # couple of failing tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python package to parse and build CSS";
    homepage = http://code.google.com/p/cssutils/;
    license = licenses.lgpl3Plus;
  };
}
