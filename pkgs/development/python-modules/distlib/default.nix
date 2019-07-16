{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.2.9.post0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecb3d0e4f71d0fa7f38db6bcc276c7c9a1c6638a516d726495934a553eb3fbe0";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = https://distlib.readthedocs.io;
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

