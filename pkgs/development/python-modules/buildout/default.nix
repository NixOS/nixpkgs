{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb08f24f9e51e647e29d714f6e9ad51a4ea28673dddeed831315617bb5a805d0";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ garbas ];
  };
}
