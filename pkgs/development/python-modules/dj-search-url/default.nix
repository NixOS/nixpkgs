{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.1";
  pname = "dj-search-url";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qk0aWFJQCzwRir/dDjCz4AFv5o5+0nuFU6Z6+iDU+0A=";
  };

  build-system = [ setuptools ];

  meta = {
    homepage = "https://github.com/dstufft/dj-search-url";
    description = "Use Search URLs in your Django Haystack Application";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
