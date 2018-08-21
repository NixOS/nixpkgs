{ lib, buildOcaml, fetchurl, ocaml }:

if lib.versionAtLeast ocaml.version "4.06"
then throw "FrontC is not available for OCaml ${ocaml.version}"
else

buildOcaml rec {
  name = "FrontC";
  version = "3.4";

  src = fetchurl {
    url = "http://www.irit.fr/recherches/ARCHI/MARCH/frontc/Frontc-${version}.tgz";
    sha256 = "16dz153s92dgbw1rrfwbhscy73did87kfmjwyh3qpvs748h1sc4g";
  };

  meta = with lib; {
    homepage = https://www.irit.fr/recherches/ARCHI/MARCH/rubrique.php3?id_rubrique=61;
    description = "C Parsing Library";
    license = licenses.lgpl21;
    maintainers = [ maintainers.maurer ];
  };

  meta_file = fetchurl {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/0f0e610f6499bdf0151e4170411b4f05e4d076d4/packages/FrontC/FrontC.3.4/files/META;
    sha256 = "1flhvwr01crn7d094kby0418s1m4198np85ymjp3b4maz0n7m2mx";
  };

  opam_patch = fetchurl {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/0f0e610f6499bdf0151e4170411b4f05e4d076d4/packages/FrontC/FrontC.3.4/files/opam.patch;
    sha256 = "0xf83ixx0mf3mznwpwp2mjflii0njdzikhhfxpnms7vhnnmlfzy5";
  };

  patches = [ opam_patch ];
  patchFlags = "-p4";

  makeFlags = "PREFIX=$(out) OCAML_SITE=$(OCAMLFIND_DESTDIR)";

  postInstall = "cp ${meta_file} $OCAMLFIND_DESTDIR/FrontC/META";
}
