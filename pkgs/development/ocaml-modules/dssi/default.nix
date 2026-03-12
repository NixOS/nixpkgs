{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ladspa,
  alsa-lib,
}:

buildDunePackage (finalAttrs: {
  pname = "dssi";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dssi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pkeiAawAraPPk1X71DZ1s5rsMeShz2UyMJfbr0KvK7s=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ladspa
    alsa-lib
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-dssi";
    description = "Bindings for the DSSI API which provides audio synthesizers";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
