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
  version = "1.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5X5WOlf7IqFC2jTziswvwaXIZLwpyhUXqIq8lj5g1uw=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ cppy ];

  pythonImportsCheck = [ "kiwisolver" ];

  meta = with lib; {
    description = "Implementation of the Cassowary constraint solver";
    homepage = "https://github.com/nucleic/kiwi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
