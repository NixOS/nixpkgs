{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  pkg-config,
  gsl,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "gsl";
  version = "1.25.1";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "gsl-ocaml";
    rev = version;
    hash = "sha256-h1jO2RheBBzxiBgig2yEPk4YyBaZxStt5f+KNZqHdBo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    gsl
  ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/gsl-ocaml/";
    description = "OCaml bindings to the GNU Scientific Library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
