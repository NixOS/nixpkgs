{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "polib";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aikb8gcarhifn3sadrbbs5czagih9hjv250gsrgy9v1d49pvn7s";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library to manipulate gettext files (po and mo files)";
    homepage = https://bitbucket.org/izi/polib/;
    license = licenses.mit;
  };
}
