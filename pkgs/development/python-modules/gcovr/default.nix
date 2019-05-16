{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca94c337f2d9a70db177ec4330534fad7b2b772beda625c1ec071fbcf1361e22";
  };

  meta = with stdenv.lib; {
    description = "A Python script for summarizing gcov data";
    license = licenses.bsd0;
    homepage = http://gcovr.com/;
  };

}
