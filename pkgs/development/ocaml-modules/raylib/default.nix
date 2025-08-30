{
  lib,
  fetchurl,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "fix-build-with-patch-3.0.0.patch";
      url = "https://github.com/tjammer/raylib-ocaml/commit/40e6fef44e3c39d4526806c4b830da77c4fe4bb8.patch";
      excludes = [
        "dune-project"
        "raygui.opam"
      ];
      hash = "sha256-MEZkkBgjL2iT6Av/s0tJCrW7+oyp9QD6sUbXEusCAWI=";
    })
  ];

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
