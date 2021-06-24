{ stdenv, lib, fetchFromGitHub, ocaml, findlib, opaline
, calendar, eliom, js_of_ocaml-ppx_deriving_json
}:

stdenv.mkDerivation rec {
 pname = "ocsigen-toolkit";
 name = "ocaml${ocaml.version}-${pname}-${version}";
 version = "2.7.0";

 propagatedBuildInputs = [ calendar js_of_ocaml-ppx_deriving_json eliom ];
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
    sha256 = "0jan5779nc0jf993hmvfii15ralcs20sm4mcnqwqrnhjbq6f6zpk";
  };

  createFindlibDestdir = true;

  meta = {
    homepage = "http://ocsigen.org/ocsigen-toolkit/";
    description = " User interface widgets for Ocsigen applications";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
    inherit (ocaml.meta) platforms;
  };


}
