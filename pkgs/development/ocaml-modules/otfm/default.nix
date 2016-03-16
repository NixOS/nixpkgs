{ stdenv, fetchurl, ocaml, findlib, opam, uutf }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "otfm";
  version = "0.2.0";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1wgi9plf98gd7x3b7fzjxds089sivsap97bl1bw2lj73nxwnyb9c";
  };

  buildInputs = [ ocaml findlib opam ];

  propagatedBuildInputs = [ uutf ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    description = "OpenType font decoder for OCaml";
    longDescription = ''
      Otfm is an in-memory decoder for the OpenType font data format. It
      provides low-level access to font tables and functions to decode some
      of them.
    '';
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
