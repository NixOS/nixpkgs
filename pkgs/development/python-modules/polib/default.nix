{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "polib";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fad87d13696127ffb27ea0882d6182f1a9cf8a5e2b37a587751166c51e5a332a";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library to manipulate gettext files (po and mo files)";
    homepage = "https://bitbucket.org/izi/polib/";
    license = licenses.mit;
  };
}
