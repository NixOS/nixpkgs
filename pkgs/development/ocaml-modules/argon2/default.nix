{
  lib,
  fetchurl,
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

  src = fetchurl {
    url = "https://github.com/Khady/ocaml-argon2/releases/download/${version}/argon2-${version}.tbz";
    hash = "sha256-NDsOV4kPT2SnSfNHDBAK+VKZgHDIKxW+dNJ/C5bQ8gU=";
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
