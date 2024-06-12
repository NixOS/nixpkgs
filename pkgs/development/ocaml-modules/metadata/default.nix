{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, flac }:

buildDunePackage rec {
  pname = "metadata";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-metadata";
    rev = "v${version}";
    sha256 = "sha256-SQ8fNl62fvoCgbIt0axQyE3Eqwl8EOtYiz3xN96al+g=";
  };

  minimalOCamlVersion = "4.14";

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-metadata";
    description = "Library to read metadata from files in various formats. ";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
