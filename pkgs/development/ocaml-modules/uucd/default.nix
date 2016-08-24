{ stdenv, fetchurl, ocaml, findlib, opam, xmlm, topkg }:
let
  pname = "uucd";
  version = "4.0.0";
  webpage = "http://erratique.ch/software/${pname}";
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in
stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "11cjfwa4wjhsyvzq4wl9z44xi28n49drz8nbfpx754vyfzwj3yc6";
  };

  buildInputs = [ ocaml findlib opam topkg ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (topkg) buildPhase;

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml_version}/site-lib/
  '';

  propagatedBuildInputs = [ xmlm ];

  meta = with stdenv.lib; {
    description = "An OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
