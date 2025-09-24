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

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
