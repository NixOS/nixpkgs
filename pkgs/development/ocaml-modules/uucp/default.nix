{ stdenv, fetchurl, ocaml, findlib, opam }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "uucp";
  version = "1.1.0";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.00";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1vm5f2ppdrnk19j0ppjiqz56qf5bzyk26gs0lz071s7iblk459jz";
  };

  buildInputs = [ ocaml findlib opam ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    description = "An OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
