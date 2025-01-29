{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  ogg,
  flac,
}:

buildDunePackage rec {
  pname = "flac";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-flac";
    rev = "v${version}";
    sha256 = "sha256-68zunpRIX4lrRsKJhDF3Sre6Rp3g+ntP19ObFqG57jE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    flac.dev
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-flac";
    description = "Bindings for flac";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
