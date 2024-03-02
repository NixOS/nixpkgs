{ buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, SDL2
, SDL2_ttf
, tsdl
}:

buildDunePackage rec {
  pname = "tsdl-ttf";
  version = "0.5";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-ai9ChsA3HZzTxT9AuHsY1UIA2Q3U3CcOA7jRSG4MDsQ=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_ttf
    tsdl
  ];

  meta = with lib; {
    description = "SDL2_ttf bindings for Ocaml with Tsdl";
    homepage = "https://github.com/sanette/tsdl-ttf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
