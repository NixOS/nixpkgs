{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libmad,
}:

buildDunePackage rec {
  pname = "mad";
  version = "0.5.3";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-mad";
    rev = "v${version}";
    sha256 = "sha256-rSFzWyUYTrGL7GvVsY5qKdCXqY/XJQkuBerexG838jc=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libmad ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-mad";
    description = "Bindings for the mad library which provides functions for encoding wave audio files into mp3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
