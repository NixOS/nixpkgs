{
  lib,
  fetchzip,
  buildDunePackage,
  ocaml,
  zarith,
  eqaf,
  bigarray-compat,
  hex,
  ff-sig,
  ff,
  alcotest,
  bisect_ppx,
}:

buildDunePackage rec {
  pname = "mec";
  version = "0.1.0";
  src = fetchzip {
    url = "https://gitlab.com/nomadic-labs/cryptography/ocaml-ec/-/archive/${version}/ocaml-ec-${version}.tar.bz2";
    sha256 = "sha256-uIcGj/exSfuuzsv6C/bnJXpYRu3OY3dcKMW/7+qwi2U=";
  };

  duneVersion = "3";

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [
    eqaf
    bigarray-compat
    hex
    ff-sig
    ff
    alcotest
  ];

  buildInputs = [
    zarith
  ];

  checkInputs = [
    alcotest
    bisect_ppx
  ];

  meta = {
    description = "Mec - Mini Elliptic Curve library";
    homepage = "https://gitlab.com/nomadic-labs/cryptography/ocaml-ec";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
