{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "cry";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-cry";
    rev = version;
    sha256 = "1g4smccj27sv8pb9az5hbzxi99swg3d55mp7j25lz30xyabvksc3";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-cry";
    description = "OCaml client for the various icecast & shoutcast source protocols";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
