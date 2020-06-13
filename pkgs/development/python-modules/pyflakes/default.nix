{ stdenv, buildPythonPackage, fetchPypi, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j3zqbiwkyicvww499bblq33x0bjpzdrxajhaysr7sk7x5gdgcim";
  };

  checkInputs = [ unittest2 ];

  meta = with stdenv.lib; {
    homepage = "https://launchpad.net/pyflakes";
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
