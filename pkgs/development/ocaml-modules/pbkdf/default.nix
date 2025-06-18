{
  lib,
  buildDunePackage,
  fetchzip,
  digestif,
  mirage-crypto,
  alcotest,
  ohex,
}:

buildDunePackage rec {
  pname = "pbkdf";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/abeaumont/ocaml-pbkdf/archive/${version}.tar.gz";
    hash = "sha256-D2dXpf1D/wsJrcajU3If37tuLYjahoA/+QoXZKr1vQs=";
  };

  minimalOCamlVersion = "4.08";
  propagatedBuildInputs = [
    digestif
    mirage-crypto
  ];
  checkInputs = [
    alcotest
    ohex
  ];
  doCheck = true;

  meta = {
    description = "Password based key derivation functions (PBKDF) from PKCS#5";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/abeaumont/ocaml-pbkdf";
  };
}
