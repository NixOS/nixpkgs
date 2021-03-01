{ lib, buildDunePackage, fetchFromGitHub
, dune-configurator
, posix-socket
, srt
}:

buildDunePackage rec {
  pname = "srt";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-srt";
    rev = "v${version}";
    sha256 = "0xh89w4j7lljvpy2n08x6m9kw88f82snmzf23kp0gw637sjnrj6f";
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
