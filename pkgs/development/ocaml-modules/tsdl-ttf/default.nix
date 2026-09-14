{
  buildDunePackage,
  dune-configurator,
  fetchFromGitHub,
  lib,
  SDL2,
  SDL2_ttf,
  tsdl,
}:

buildDunePackage rec {
  pname = "tsdl-ttf";
  version = "0.7";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-ElEZG4btWa9zKEJxYTiiPeTD+neJZlnqBunPgSyK1kI=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_ttf
    tsdl
  ];

  meta = {
    description = "SDL2_ttf bindings for Ocaml with Tsdl";
    homepage = "https://github.com/sanette/tsdl-ttf";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
