{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.1";
  format = "setuptools";
  pname = "dj-search-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "424d1a5852500b3c118abfdd0e30b3e0016fe68e7ed27b8553a67afa20d4fb40";
  };

  meta = with lib; {
    homepage = "https://github.com/dstufft/dj-search-url";
    description = "Use Search URLs in your Django Haystack Application";
    license = licenses.bsd0;
    maintainers = [ ];
  };

}
