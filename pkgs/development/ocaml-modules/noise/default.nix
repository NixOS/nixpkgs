{ lib
, buildDunePackage
, fetchurl

, callipyge
, chacha
, digestif
, hex
, lwt
, lwt_ppx
, nocrypto
, ounit
, ppxlib
, ppx_let
, ppx_deriving
, ppx_deriving_yojson
}:

buildDunePackage rec {
  pname = "noise";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/emillon/ocaml-noise/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-fe3pT7fsuF2hCvXpInsRg6OvARs/eAh1Un454s1osDs=";
  };

  postPatch = ''
    substituteInPlace tweetnacl/lib/tweetnacl.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace chacha20/lib/chacha20.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace lib/symmetric_state.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace lib/cipher_chacha_poly.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace lib/cipher_aes_gcm.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace lib/state.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace test/unit/test_cipher_aes_gcm.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace test/examples/noise_demo_two_way.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
    substituteInPlace test/examples/noise_demo_one_way.ml \
      --replace 'Cstruct.len' 'Cstruct.length'
  '';

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  nativeBuildInputs = [
    ppxlib
    ppx_deriving
    ppx_let
  ];

  propagatedBuildInputs = [
    callipyge
    chacha
    digestif
    hex
    nocrypto
  ];

  doCheck = true;
  checkInputs = [
    lwt
    lwt_ppx
    ounit
    ppx_deriving_yojson
  ];

  meta = {
    homepage = "https://github.com/emillon/ocaml-noise";
    description = "OCaml implementation of the Noise Protocol Framework";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
