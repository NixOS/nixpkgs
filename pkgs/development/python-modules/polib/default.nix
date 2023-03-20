{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "polib";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8++Urv7W4YPjQqiiaa4fxHQroZMYatdvF1k4Yh2/wms=";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with lib; {
    description = "A library to manipulate gettext files (po and mo files)";
    homepage = "https://bitbucket.org/izi/polib/";
    license = licenses.mit;
  };
}
