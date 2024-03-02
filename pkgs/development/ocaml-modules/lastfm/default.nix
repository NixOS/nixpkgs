{ lib
, buildDunePackage
, fetchFromGitHub
, pkg-config
, dune-configurator
, xmlplaylist
, ocaml_pcre
, ocamlnet
}:

buildDunePackage rec {
  pname = "lastfm";
  version = "0.3.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lastfm";
    rev = "v${version}";
    sha256 = "1sz400ny9h7fs20k7600q475q164x49ba30ls3q9y35rhm3g2y2b";
  };

  propagatedBuildInputs = [ xmlplaylist ocaml_pcre ocamlnet ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lastfm";
    description = "OCaml API to lastfm radio and audioscrobbler";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
