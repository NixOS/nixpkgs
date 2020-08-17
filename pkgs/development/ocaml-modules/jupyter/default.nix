{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  base,
  uuidm,
  base64,
  ocaml_lwt,
  lwt_ppx,
  logs,
  stdint,
  zmq,
  zmq-lwt,
  yojson,
  ppx_deriving_yojson,
  cryptokit,
  opam,
}:

buildDunePackage rec {
  pname = "jupyter";
  version = "f886e34f3a456b2d1ed3990e30f3783d1fbf7b99";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "akabe";
    repo   = "ocaml-jupyter";
    rev = version;
    sha256 = "13x079g2fqqmz4hw64qxvy3jwmysg26lis9svmhvq14ydn65din1";
  };

  buildInputs = [
    base
    uuidm
    base64
    ocaml_lwt
    lwt_ppx
    logs
    stdint
    zmq
    zmq-lwt
    yojson
    ppx_deriving_yojson
    cryptokit
    opam
  ];

  meta = {
    homepage = https://github.com/akabe/ocaml-jupyter;
    description = "An OCaml kernel for Jupyter (IPython) notebook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kwshi ];
  };
}
