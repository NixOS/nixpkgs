{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libogg,
}:

buildDunePackage rec {
  pname = "ogg";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-xiph";
    tag = "v${version}";
    hash = "sha256-mVMuPPjQRfwtQqpoUaEtTilMcGO0MJ4xiOd0D7ucOEQ=";
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ogg";
    description = "Bindings to libogg";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
