{
  buildDunePackage,
  dune-configurator,
  fetchFromGitHub,
  lib,
  SDL2,
  SDL2_mixer,
  tsdl,
}:

buildDunePackage rec {
  pname = "tsdl-mixer";
  version = "0.5";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-HGtO5iO3lxuVa707MDIhw0pgDZLHt9qY+Rd24sFkags=";
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
    maintainers = with maintainers; [ ];
  };
}
