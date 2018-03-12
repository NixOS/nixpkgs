{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "polib";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16klwlswfbgmkzrra80fgzhic9447pk3mnr75r2fkz72bkvpcclb";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library to manipulate gettext files (po and mo files)";
    homepage = https://bitbucket.org/izi/polib/;
    license = licenses.mit;
  };
}
