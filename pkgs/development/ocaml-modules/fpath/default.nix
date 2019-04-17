{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, astring }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fpath-0.7.2";
  src = fetchurl {
    url = http://erratique.ch/software/fpath/releases/fpath-0.7.2.tbz;
    sha256 = "1hr05d8bpqmqcfdavn4rjk9rxr7v2zl84866f5knjifrm60sxqic";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ astring ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml module for handling file system paths with POSIX and Windows conventions";
    homepage = https://erratique.ch/software/fpath;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
