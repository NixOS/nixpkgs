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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    sha256 = "sha256-UDRhwnanrn87/PYVnacur1z/LsKuUu2G+0QQXjTw/IE=";
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
    maintainers = with maintainers; [ superherointj ];
  };
}
