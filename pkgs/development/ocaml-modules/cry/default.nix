{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "cry";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-cry";
    rev = "v${version}";
    sha256 = "sha256-wn9hLqbydzFTdYsJ1e76dmDLtwcZ7CGjbzFe5o9veYQ=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace bytes ""
  '';

  minimalOCamlVersion = "4.12";

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-cry";
    description = "OCaml client for the various icecast & shoutcast source protocols";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
