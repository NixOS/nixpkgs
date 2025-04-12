{
  lib,
  buildPythonPackage,
  fetchPypi,
  stdenv,
  libcxx,
  cppy,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.4.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mJP/gb1xB/e2hdMBfMZYParbT8JuSoiDUN9TDkGYCmA=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

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
