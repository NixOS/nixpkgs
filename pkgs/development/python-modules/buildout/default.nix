{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dyc5g3yv7wm3hf3fcsh6y1wivzjj1bspafr5qqb653z9a31lsfn";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.buildout.org";
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
