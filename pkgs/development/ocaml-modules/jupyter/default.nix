{ lib
, fetchurl
, buildDunePackage
, cppo
, base
, uuidm
, base64
, lwt
, lwt_ppx
, logs
, stdint
, zmq
, zmq-lwt
, yojson
, ppx_yojson_conv
, ppx_deriving
, cryptokit
, opam
, ounit2
, ocp-indent
}:

buildDunePackage rec {
  pname = "jupyter";
  version = "2.8.2";

  minimumOCamlVersion = "4.10";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/akabe/ocaml-jupyter/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-npQcQyksrSknCHngqbORAqgwn2j3UFWFTVeixRiU+DQ=";
  };

  nativeBuildInputs = [
    cppo
  ];

  buildInputs = [
    base
    uuidm
    base64
    lwt
    lwt_ppx
    logs
    stdint
    zmq
    zmq-lwt
    yojson
    ppx_yojson_conv
    ppx_deriving
    cryptokit
  ];

  propagatedBuildInputs = [ opam ];

  checkInputs = [
    ounit2
    ocp-indent
  ];

  meta = {
    homepage = https://github.com/akabe/ocaml-jupyter;
    description = "An OCaml kernel for Jupyter (IPython) notebook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kwshi ];
    mainProgram = "ocaml-jupyter-opam-genspec";
  };
}
