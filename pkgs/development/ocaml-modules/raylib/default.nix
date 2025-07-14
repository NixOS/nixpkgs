{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  ctypes,
  integers,
  patch,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
}:

buildDunePackage rec {
  pname = "raylib";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/tjammer/raylib-ocaml/releases/download/${version}/raylib-${version}.tbz";
    hash = "sha256-/SeKgQOrhsAgMNk6ODAZlopL0mL0lVfCTx1ugmV1P/s=";
  };

  buildInputs = [
    dune-configurator
    patch
  ];

  propagatedBuildInputs = [
    ctypes
    integers
    libGL
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
  ];

  meta = {
    description = "OCaml bindings for Raylib (5.0.0)";
    homepage = "https://tjammer.github.io/raylib-ocaml";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mit;
  };
}
