{ buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, SDL2
, SDL2_image
, tsdl
}:

buildDunePackage rec {
  pname = "tsdl-image";
  version = "0.5";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-khLhVJuiLNNWw76gTeg4W32v5XbkwAg11bIOWl67u2k=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_image
    tsdl
  ];

  meta = with lib; {
    description = "OCaml SDL2_image bindings to go with Tsdl";
    homepage = "https://github.com/sanette/tsdl-image";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
