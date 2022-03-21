{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg
, astring, fmt, fpath, logs, rresult
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-bos";
  version = "0.2.0";

  src = fetchurl {
    url = "https://erratique.ch/software/bos/releases/bos-${version}.tbz";
    sha256 = "1s10iqx8rgnxr5n93lf4blwirjf8nlm272yg5sipr7lsr35v49wc";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ astring fmt fpath logs rresult ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Basic OS interaction for OCaml";
    homepage = "https://erratique.ch/software/bos";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
