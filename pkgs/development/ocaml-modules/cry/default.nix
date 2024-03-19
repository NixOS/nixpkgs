{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "cry";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-cry";
    rev = "v${version}";
    hash = "sha256-wtilYOUOHElW8ZVxolMNomvT//ho2tACmoubEvU2bpQ=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace-warn bytes ""
  '';

  minimalOCamlVersion = "4.12";

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-cry";
    description = "OCaml client for the various icecast & shoutcast source protocols";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
