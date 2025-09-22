{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyplatec";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyPlatec";
    inherit version;
    sha256 = "0kqx33flcrrlipccmqs78d14pj5749bp85b6k5fgaq2c7yzz02jg";
  };

  env.NIX_CFLAGS_COMPILE = "-std=c++11";

  meta = with lib; {
    description = "Library to simulate plate tectonics with Python bindings";
    homepage = "https://github.com/Mindwerks/plate-tectonics";
    license = licenses.lgpl3;
  };
}
