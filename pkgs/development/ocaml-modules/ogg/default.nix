{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, libogg }:

buildDunePackage rec {
  pname = "ogg";
  version = "0.7.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ogg";
    rev = "v${version}";
    sha256 = "sha256-EY1iVtB5M8//KJPT9FMDYVeBrE/lT30fCqTjjKKnWZU=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ogg";
    description = "Bindings to libogg";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
