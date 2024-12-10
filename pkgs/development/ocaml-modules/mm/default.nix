{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  alsa,
  ao,
  mad,
  pulseaudio,
  theora,
}:

buildDunePackage rec {
  pname = "mm";
  version = "0.8.5";

  duneVersion = "3";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-mm";
    rev = "v${version}";
    sha256 = "sha256-/83coQdUoaa1+5yapF/joV87uYpVsmWU7LH867Vmmo0=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    alsa
    ao
    mad
    pulseaudio
    theora
  ]; # ocamlsdl is blocked in nixpkgs from building for ocaml >= 4.06

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-mm";
    description = "High-level library to create and manipulate multimedia streams";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
