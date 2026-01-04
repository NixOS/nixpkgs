{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  shine,
}:

buildDunePackage rec {
  pname = "shine";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-shine";
    tag = "v${version}";
    sha256 = "sha256-x/ubqPXT89GWYV9KIyzny0rJDB3TBurLX71i0DlvHLU=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ shine ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-shine";
    description = "Bindings to the fixed-point mp3 encoding library shine";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
