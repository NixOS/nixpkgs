{ stdenv, lib, fetchFromGitHub, ocaml, findlib, opaline
, calendar, eliom, js_of_ocaml-ppx_deriving_json
}:

stdenv.mkDerivation rec {
 pname = "ocsigen-toolkit";
 name = "ocaml${ocaml.version}-${pname}-${version}";
 version = "3.2.0";

 propagatedBuildInputs = [ calendar js_of_ocaml-ppx_deriving_json eliom ];
 nativeBuildInputs = [ ocaml findlib opaline eliom ];

  strictDeps = true;

 installPhase = ''
    runHook preInstall
    mkdir -p $OCAMLFIND_DESTDIR
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
    make install
    opaline -prefix $out
    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "sha256:13n0y8a80bl94la4lnp9dr2x7b8plhm17g9zgf0l6x42g3886pw7";
  };

  meta = {
    homepage = "http://ocsigen.org/ocsigen-toolkit/";
    description = " User interface widgets for Ocsigen applications";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
    inherit (ocaml.meta) platforms;
  };


}
