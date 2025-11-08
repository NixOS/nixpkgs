{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  ctypes,
  ctypes-foreign,
  result,
  SDL2,
  pkg-config,
}:

let
  pname = "tsdl";
  version = "1.1.0";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-${pname}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-ZN4+trqesU1IREKcwm1Ro37jszKG8XcVigoE4BdGhzs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [
    SDL2
    ctypes
    ctypes-foreign
  ];

  preConfigure = ''
    # The following is done to avoid an additional dependency (ncurses)
    # due to linking in the custom bytecode runtime. Instead, just
    # compile directly into a native binary, even if it's just a
    # temporary build product.
    substituteInPlace myocamlbuild.ml \
      --replace ".byte" ".native"
  '';

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = webpage;
    description = "Thin bindings to the cross-platform SDL library";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.03";
  };
}
