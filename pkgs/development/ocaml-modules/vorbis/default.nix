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

  meta = {
    homepage = "https://github.com/savonet/ocaml-vorbis";
    description = "Bindings to libvorbis";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
