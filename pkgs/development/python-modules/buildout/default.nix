{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff5d7e8a1361da8dfe1025d35ef6ce55e929dd8518d2a811a1cf2c948950a043";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ garbas ];
  };
}
