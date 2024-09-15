{ buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, SDL2
, SDL2_mixer
, tsdl
}:

buildDunePackage rec {
  pname = "tsdl-mixer";
  version = "0.6";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-szuGmLzgGyQExCQwpopVNswtZZdhP29Q1+uNQJZb43Q=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_mixer
    tsdl
  ];

  meta = with lib; {
    description = "SDL2_mixer bindings to go with Tsdl";
    homepage = "https://github.com/sanette/tsdl-mixer";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
