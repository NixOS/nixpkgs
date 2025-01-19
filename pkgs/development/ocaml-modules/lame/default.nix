{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  pkg-config,
  dune-configurator,
  lame,
}:

buildDunePackage rec {
  pname = "lame";
  version = "0.3.7";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lame";
    rev = "v${version}";
    sha256 = "sha256-/ZzoGFQQrBf17TaBPSFDQ1yHaQnva56YLmscOacrKBI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ lame ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lame";
    description = "Bindings for the lame library which provides functions for encoding mp3 files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
