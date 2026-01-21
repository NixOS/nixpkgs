{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyplatec";
  version = "1.4.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyPlatec";
    inherit version;
    sha256 = "sha256-PXQlJtC4Z0ifphqTelOuBQS5wubxCH/f0PSWnE7OeNg=";
  };

  env.NIX_CFLAGS_COMPILE = "-std=c++11";

  meta = {
    description = "Library to simulate plate tectonics with Python bindings";
    homepage = "https://github.com/Mindwerks/plate-tectonics";
    license = lib.licenses.lgpl3;
  };
}
