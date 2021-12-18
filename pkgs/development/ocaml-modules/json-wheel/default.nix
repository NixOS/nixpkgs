{ stdenv
, lib
, fetchurl
, ocaml
, findlib
, which
, ocamlnet
}:

stdenv.mkDerivation rec {
  pname = "json-wheel";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/mjambon/mjambon2016/raw/bd644e0a42cacba56d0260982614d1ef5c8305b3/json-wheel-1.0.6.tar.bz2";
    sha256 = "BYLDP2iG4Yr8izqcMsdjcqFdO8OXSci8G+iLvYrXH8U=";
  };

  patches = [
    # Fix build.
    (fetchurl {
      name = "json-wheel-1.0.6-safe-string.patch";
      url = "https://github.com/ocaml/opam-repository/raw/master/packages/json-wheel/json-wheel.1.0.6%2Bsafe-string/files/json-wheel-1.0.6%2Bsafe-string.patch";
      sha256 = "dvouBFBauQxNElBrhQxVNpos5G+7FYqLwniXGLQTsqQ=";
    })
  ];

  nativeBuildInputs = [
    ocaml
    findlib
    which
  ];

  buildInputs = [
    ocamlnet
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/ocaml/${ocaml.version}/site-lib" "$out/bin"
  '';

  strictDeps = true;

  meta = {
    homepage = "https://opam.ocaml.org/packages/json-wheel/";
    description = "JSON parser and writer, with optional C-style comments";
    license = lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
