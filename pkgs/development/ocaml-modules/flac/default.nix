{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  ogg,
  flac,
}:

buildDunePackage {
  pname = "flac";
  inherit (ogg) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    flac.dev
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-flac";
    description = "Bindings for flac";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
