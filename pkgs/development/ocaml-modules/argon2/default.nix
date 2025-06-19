{
  lib,
  fetchFromGitHub,
  ctypes,
  ctypes-foreign,
  dune-configurator,
  result,
  libargon2,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "argon2";
  version = "1.0.2";

  minimalOCamlVersion = "4.02.3";

  src = fetchFromGitHub {
    owner = "Khady";
    repo = "ocaml-argon2";
    rev = version;
    hash = "sha256-m5yOMT33Z9LfjQg6QRBW6mjHNyIySq6somTFuGmL9xI=";
  };

  buildInputs = [
    dune-configurator
    libargon2
  ];

  propagatedBuildInputs = [
    ctypes
    ctypes-foreign
    result
  ];

  meta = {
    homepage = "https://github.com/Khady/ocaml-argon2";
    description = "Ocaml bindings to Argon2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naora ];
  };
}
