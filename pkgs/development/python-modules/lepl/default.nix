{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "LEPL";
  version = "5.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qksjl1shj4gp47wf21h79qcs35h9b54pgdmzj0qd88jdq5qwd8";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.acooke.org/lepl/";
    description = "A recursive descent parser for Python 2.6+";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
