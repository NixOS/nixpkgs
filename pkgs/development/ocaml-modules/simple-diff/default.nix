{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  topkg,
  ocamlbuild,
  re,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-simple-diff";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "gjaldon";
    repo = "simple_diff";
    rev = "v${version}";
    sha256 = "sha256-OaKECUBCCt9KfdRJf3HcXTUJVxKKdYtnzOHpMPOllrk=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ re ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = "https://github.com/gjaldon/simple_diff";
    description = "Simple_diff is a pure OCaml diffing algorithm";
    license = licenses.isc;
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
