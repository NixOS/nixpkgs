{ stdenv, fetchurl, ocaml, findlib, opam, uucp, uutf, cmdliner }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "uuseg";
  version = "0.8.0";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.01";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "00n4zi8dyw2yzi4nr2agcrr33b0q4dr9mgnkczipf4c0gm5cm50h";
  };

  buildInputs = [ ocaml findlib opam cmdliner ];
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
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    description = "An OCaml library for segmenting Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
