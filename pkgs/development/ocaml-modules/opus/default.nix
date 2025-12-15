{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  ogg,
  libopus,
}:

buildDunePackage {
  pname = "opus";
  inherit (ogg) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    libopus.dev
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
