{ stdenv, buildOcaml, fetchurl, ocaml, findlib, ocamlbuild, opam, uucp, uutf, cmdliner }:

let
  pname = "uuseg";
  webpage = "http://erratique.ch/software/${pname}";
in

buildOcaml rec {

  minimumSupportedOcamlVersion = "4.01";

  name = pname;
  version = "0.9.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "00n4zi8dyw2yzi4nr2agcrr33b0q4dr9mgnkczipf4c0gm5cm50h";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam cmdliner ];
  propagatedBuildInputs = [ uucp uutf ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = ''
    ocaml pkg/build.ml \
      native=true native-dynlink=true \
      uutf=true cmdliner=true
  '';

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml.version}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    description = "An OCaml library for segmenting Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
