{ lib
, buildDunePackage
, fetchFromGitHub
, re
, xmlplaylist
}:

buildDunePackage rec {
  pname = "lastfm";
  version = "0.3.4";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lastfm";
    rev = "v${version}";
    sha256 = "sha256-1te9B2+sUmkT/i2K5ueswWAWpvJf9rXob0zR4CMOJlg=";
  };

  propagatedBuildInputs = [
    re
    xmlplaylist
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lastfm";
    description = "OCaml API to lastfm radio and audioscrobbler";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
