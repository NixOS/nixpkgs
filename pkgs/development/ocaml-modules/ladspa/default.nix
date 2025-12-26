{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ladspaH,
}:

buildDunePackage (finalAttrs: {
  pname = "ladspa";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ladspa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f31J9mdr7GDAUq7Fu4at2jf8wxgcK7X9vyp9JZ2NA/k=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ladspaH ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-alsa";
    description = "Bindings for the LADSPA API which provides audio effects";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.dandellion ];
  };
})
