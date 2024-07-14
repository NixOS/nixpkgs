{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.1";
  format = "setuptools";
  pname = "dj-search-url";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qk0aWFJQCzwRir/dDjCz4AFv5o5+0nuFU6Z6+iDU+0A=";
  };

  meta = with lib; {
    homepage = "https://github.com/dstufft/dj-search-url";
    description = "Use Search URLs in your Django Haystack Application";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
