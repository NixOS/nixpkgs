{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "cry";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-cry";
    rev = "v${version}";
    sha256 = "sha256-1Omp3LBKGTPVwEBd530H0Djn3xiEjOHLqso6S8yIJSQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-cry";
    description = "OCaml client for the various icecast & shoutcast source protocols";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
