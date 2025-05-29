{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ogg,
  libvorbis,
}:

buildDunePackage rec {
  pname = "vorbis";
  version = "0.8.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-vorbis";
    rev = "v${version}";
    hash = "sha256-iCoE7I70wAp4n4XfETVKeaob2811E97/e6144bY/nqk=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    libvorbis
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-vorbis";
    description = "Bindings to libvorbis";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
