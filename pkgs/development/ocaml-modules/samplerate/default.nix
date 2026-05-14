{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libsamplerate,
}:

buildDunePackage (finalAttrs: {
  pname = "samplerate";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-samplerate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N3PSUSZ1tKNJcNPSgye6+8QQXcZIez72jk/YdNNOEUA=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libsamplerate ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-samplerate";
    description = "Interface for libsamplerate";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
