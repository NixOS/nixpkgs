{ stdenv, fetchFromGitHub, ocaml, findlib, opaline
, calendar, eliom, js_of_ocaml-ppx_deriving_json
}:

stdenv.mkDerivation rec {
 pname = "ocsigen-toolkit";
 name = "ocaml${ocaml.version}-${pname}-${version}";
 version = "2.0.0";

 propagatedBuildInputs = [ calendar eliom js_of_ocaml-ppx_deriving_json ];
 buildInputs = [ ocaml findlib opaline ];

 installPhase =
  ''
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
    make install
    opaline -prefix $out
  '';

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "0gkiqw3xi31l9q9h89fnr5gfmxi9w9lg9rlv16h4ssjgrgq3y5cw";
  };

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocsigen.org/ocsigen-toolkit/;
    description = " User interface widgets for Ocsigen applications";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
    inherit (ocaml.meta) platforms;
  };


}
