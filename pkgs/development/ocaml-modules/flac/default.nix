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

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-flac";
    description = "Bindings for flac";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
