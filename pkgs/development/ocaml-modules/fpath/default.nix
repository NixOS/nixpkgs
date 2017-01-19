{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, astring }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fpath-0.7.1";
  src = fetchurl {
    url = http://erratique.ch/software/fpath/releases/fpath-0.7.1.tbz;
    sha256 = "05134ij27xjl6gaqsc65yl19vfj6cjxq3mbm9bf4mija8grdpn6g";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild opam topkg ];

  propagatedBuildInputs = [ astring ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml module for handling file system paths with POSIX and Windows conventions";
    homepage = http://erratique.ch/software/fpath;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
