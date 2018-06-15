{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d616a382f243dbf19b54743f280b80198be0bca3a5396f1d2e1fca6223e8805";
  };

  buildInputs = [ unittest2 ];

  doCheck = !isPyPy;

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pyflakes;
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
