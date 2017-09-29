{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "1.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x1pcca4a24k4pw8x1c77sgi58cg1wl2k38mp8a25k608pzls3da";
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
