{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ogg,
  libvorbis,
}:

buildDunePackage {
  pname = "vorbis";
  inherit (ogg) version src;

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
