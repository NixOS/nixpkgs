{ lib, buildDunePackage, fetchFromGitHub
, dune-configurator
, posix-socket
, srt
}:

buildDunePackage rec {
  pname = "srt";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-srt";
    rev = "v${version}";
    sha256 = "sha256-rnM50IzeiKOrpFf79jTHp+fXn0tdx+vrLuD3kzqLh5g=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ posix-socket srt ];

  meta = {
    description = "OCaml bindings for the libsrt library";
    license = lib.licenses.gpl2Only;
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
