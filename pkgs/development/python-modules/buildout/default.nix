{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a73s5q548l2vs2acqs3blkzd9sw6d7ci77fz1pc9156vn3dxm2x";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
