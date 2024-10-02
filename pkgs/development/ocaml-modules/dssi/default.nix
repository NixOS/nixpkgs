{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ladspa, alsa-lib }:

buildDunePackage rec {
  pname = "dssi";
  version = "0.1.5";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dssi";
    rev = "v${version}";
    sha256 = "1frbmx1aznwp60r6bkx1whqyr6mkflvd9ysmjg7s7b80mh0s4ix6";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ladspa alsa-lib ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-dssi";
    description = "Bindings for the DSSI API which provides audio synthesizers";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
