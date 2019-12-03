{ stdenv, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  name = "ounit-2.0.0";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1258/ounit-2.0.0.tar.gz;
    sha256 = "118xsadrx84pif9vaq13hv4yh22w9kmr0ypvhrs0viir1jr0ajjd";
  };

  patches = with stdenv.lib;
    optional (versionAtLeast ocaml.version "4.02") (fetchpatch {
    url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ounit/ounit.2.0.0/files/safe-string.patch";
    sha256 = "0hbd2sqdz75lv5ax82yhsfdk1dlcvq12xpys6n85ysmrl0c3d3lk";
  });

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ findlib ];
  configurePlatforms = [];

  dontAddPrefix = true;

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://ounit.forge.ocamlcore.org/;
    description = "Unit test framework for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
