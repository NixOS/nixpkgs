{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, flac }:

buildDunePackage rec {
  pname = "metadata";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-metadata";
    rev = "v${version}";
    sha256 = "sha256-sSekkyJ8D6mCCmxIyd+pBk/khaehA3BcpUQl2Gln+Ic=";
  };

  minimalOCamlVersion = "4.14";

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-metadata";
    description = "Library to read metadata from files in various formats. ";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
