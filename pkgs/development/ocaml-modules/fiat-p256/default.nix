{ lib, buildDunePackage, fetchurl, alcotest, asn1-combinators, benchmark
, bigarray-compat, cstruct, eqaf, hex, ppx_deriving_yojson, rresult
, stdlib-shims, yojson, dune-configurator }:

buildDunePackage rec {
  pname = "fiat-p256";
  version = "0.2.3";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/fiat/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-wg0bE5X1mxEcpqdcVbTt+4ZCFdr3SEkQvInClTR0sOA=";
  };

  # Make tests compatible with alcotest 1.4.0
  postPatch = ''
    substituteInPlace test/wycheproof/test.ml --replace \
      'Printf.ksprintf Alcotest.fail' 'Printf.ksprintf (fun s -> Alcotest.fail s)'
  '';

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bigarray-compat cstruct eqaf hex ];
  checkInputs = [ alcotest asn1-combinators benchmark
                  ppx_deriving_yojson rresult stdlib-shims yojson ];
  doCheck = true;

  meta = with lib; {
    description = "Primitives for Elliptic Curve Cryptography taken from Fiat";
    homepage = "https://github.com/mirage/fiat";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
