{
  lib,
  buildPythonPackage,
  fetchPypi,
  stdenv,
  cppy,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.4.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I9XwI73Ix+VOtl8Dyl1bsltgHqxNfxoEKIih9FI3mH4=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ cppy ];

  pythonImportsCheck = [ "kiwisolver" ];

  meta = with lib; {
    description = "Implementation of the Cassowary constraint solver";
    homepage = "https://github.com/nucleic/kiwi";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
