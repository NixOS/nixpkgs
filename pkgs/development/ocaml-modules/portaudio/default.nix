{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  portaudio,
}:

buildDunePackage rec {
  pname = "portaudio";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-portaudio";
    rev = "v${version}";
    sha256 = "sha256-rMSE+ta7ughjjCnz4oho1D3VGaAsUlLtxizvxZT0/cQ=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ portaudio ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-portaudio";
    description = "Bindings for the portaudio library which provides high-level functions for using soundcards";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
