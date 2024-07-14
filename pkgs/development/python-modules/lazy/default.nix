{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "lazy";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LG0npasTD7hUNTIGUaR0A63LN+y8xQGwxmBjkfZfW0M=";
    extension = "zip";
  };

  meta = {
    description = "Lazy attributes for Python objects";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/stefanholek/lazy";
  };
}
