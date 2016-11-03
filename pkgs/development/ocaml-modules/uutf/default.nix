{ stdenv, buildOcaml, fetchurl, ocaml, findlib, ocamlbuild, opam, cmdliner}:
let
  pname = "uutf";
  webpage = "http://erratique.ch/software/${pname}";
in

buildOcaml rec {
  name = pname;
  version = "0.9.4";

  minimumSupportedOcamlVersion = "3.12";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1f71fyawxal42x6g82539bv0ava2smlar6rmxxz1cyq3l0i6fw0k";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ cmdliner ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = ''
    ocaml pkg/git.ml
    ocaml pkg/build.ml \
      native=true \
      native-dynlink=true \
      cmdliner=true
  '';

  installPhase = ''
    opam-installer --prefix=$out --script | sh
    ln -s $out/lib/uutf $out/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = with stdenv.lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
