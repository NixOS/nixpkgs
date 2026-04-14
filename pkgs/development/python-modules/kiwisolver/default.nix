{
  lib,
  buildPythonPackage,
  fetchPypi,
  stdenv,
  cppy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w7IsJsb9aBGwroNjuVyozk6jwgLT0JdbKRQxDOsbzE0=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ cppy ];

  pythonImportsCheck = [ "kiwisolver" ];

  meta = {
    description = "Implementation of the Cassowary constraint solver";
    homepage = "https://github.com/nucleic/kiwi";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
