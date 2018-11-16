{ stdenv, fetchurl, buildOcaml, ocaml, opaline
, calendar, eliom, js_of_ocaml-ppx_deriving_json
}:

buildOcaml rec
{
 name = "ocsigen-toolkit";
 version = "1.1.0";

 propagatedBuildInputs = [ calendar eliom js_of_ocaml-ppx_deriving_json ];
 buildInputs = [ opaline ];

 installPhase =
  ''
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
    make install
    opaline -prefix $out
  '';

  src = fetchurl {
    sha256 = "1i5806gaqqllgsgjz3lf9fwlffqg3vfl49msmhy7xvq2sncbxp8a";
    url = "https://github.com/ocsigen/${name}/archive/${version}.tar.gz";
  };

  meta = {
    homepage = http://ocsigen.org/ocsigen-toolkit/;
    description = " User interface widgets for Ocsigen applications";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };


}
