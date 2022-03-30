{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, libcxx
, cppy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f2BtkbiogWvkdlE6d/0wq+ZiJwOb1vi0BsNIywJH3Mk=";
  };

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    cppy
  ];

  pythonImportsCheck = [ "kiwisolver" ];

  meta = with lib; {
    description = "A fast implementation of the Cassowary constraint solver";
    homepage = "https://github.com/nucleic/kiwi";
    license = licenses.bsd3;
  };
}
