{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libogg,
}:

buildDunePackage rec {
  pname = "ogg";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ogg";
    rev = "v${version}";
    sha256 = "sha256-S6rJw90c//a9d63weCLuOBoQwNqbpTb+lRytvHUOZuc=";
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
