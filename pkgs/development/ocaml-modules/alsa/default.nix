{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  alsa-lib,
}:

buildDunePackage (finalAttrs: {
  pname = "alsa";
  version = "0.3.0";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-alsa";
    tag = finalAttrs.version;
    hash = "sha256-EiLa4w8jfwxl6C1IT6x1tUjacgGAB7JrDmEwPM4TwuM=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ alsa-lib ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-alsa";
    description = "OCaml interface for libasound2";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
