{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyplatec";
  version = "1.4.0";

  src = fetchPypi {
    pname = "PyPlatec";
    inherit version;
    hash = "sha256-Twrwvz9MYPVcmWYVdFcip8hLQkNH48rYjTRnRt0YHU8=";
  };

  env.NIX_CFLAGS_COMPILE = "-std=c++11";

  meta = with lib; {
    description = "Library to simulate plate tectonics with Python bindings";
    homepage = "https://github.com/Mindwerks/plate-tectonics";
    license = licenses.lgpl3;
  };
}
