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
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8TA+8u7IEmKktwjD6Fiv5Y18da2RwcBSZu2nZzNphZo=";
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
