{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "metadata";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-metadata";
    tag = "v${version}";
    sha256 = "sha256-g76R1ziRv3VDl0IEJOm626m/ywDz+qgHtQg0uPb0MCU=";
  };

  minimalOCamlVersion = "4.14";

  meta = {
    homepage = "https://github.com/savonet/ocaml-metadata";
    description = "Library to read metadata from files in various formats";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
