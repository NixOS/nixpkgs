{ stdenv, fetchurl, buildOcaml, ocaml, eliom, opam }:

buildOcaml rec
{
 name = "ocsigen-toolkit";
 version = "1.0.0";

 propagatedBuildInputs = [ eliom ];
 buildInputs = [ opam ];

 createFindlibDestdir = true;

 installPhase =
  ''
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
    make install
    opam-installer --prefix=$out
  '';

  src = fetchurl {
    sha256 = "0wm4fnss7vlkd03ybgfrk63kpip6m6p6kdqjn3f64n11256mwzj2";
    url = "https://github.com/ocsigen/${name}/archive/${version}.tar.gz";
  };

  meta = {
    homepage = http://ocsigen.org/ocsigen-toolkit/;
    description = " User interface widgets for Ocsigen applications";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };


}
