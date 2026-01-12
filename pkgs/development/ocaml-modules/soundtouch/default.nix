{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  soundtouch,
}:

buildDunePackage rec {
  pname = "soundtouch";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-soundtouch";
    rev = "v${version}";
    sha256 = "sha256-81Mhk4PZx4jGrVIevzMslvVbKzipzDzHWnbtOjeZCI8=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ soundtouch ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-soundtouch";
    description = "Bindings for the soundtouch library which provides functions for changing pitch and timestretching audio data";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
