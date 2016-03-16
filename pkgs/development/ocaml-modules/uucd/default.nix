{stdenv, fetchurl, ocaml, findlib, opam, xmlm}:
let
  pname = "uucd";
  version = "2.0.0";
  webpage = "http://erratique.ch/software/${pname}";
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in
stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "12lbrrdjwdxfa99pbg344dfkj51lr5d2ispcj7d7lwsqyxy6h57i";
  };

  buildInputs = [ ocaml findlib opam xmlm ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "ocaml ./pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml_version}/site-lib/
  '';

  propagatedBuildInputs = [ xmlm ];

  meta = with stdenv.lib; {
    description = "An OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
