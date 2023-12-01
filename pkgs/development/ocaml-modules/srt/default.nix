{ lib, buildDunePackage, fetchFromGitHub
, dune-configurator
, posix-socket
, srt
}:

buildDunePackage rec {
  pname = "srt";
  version = "0.3.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-srt";
    rev = "v${version}";
    sha256 = "sha256-iD18bCbouBuMpuSzruDZJoYz2YyN080RK8BavUF3beY=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ posix-socket srt ];

  meta = with lib; {
    description = "OCaml bindings for the libsrt library";
    license = lib.licenses.gpl2Only;
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ vbgl dandellion ];
  };
}
