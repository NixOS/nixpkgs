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
    tag = version;
    hash = "sha256-m5yOMT33Z9LfjQg6QRBW6mjHNyIySq6somTFuGmL9xI=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    ctypes
    ctypes-foreign
    libargon2
    result
  ];

  meta = {
    homepage = "https://github.com/Khady/ocaml-argon2";
    description = "Ocaml bindings to Argon2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naora ];
  };
}
