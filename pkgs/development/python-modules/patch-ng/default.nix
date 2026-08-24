{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.19.1"; # note: `conan` package may require a hardcoded one
  format = "setuptools";
  pname = "patch-ng";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A2o8wAE07FPzfpIzOVjudeEX8uYqXsK4XHEi5egVwp4=";
  };

  meta = {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
