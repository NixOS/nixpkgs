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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    sha256 = "sha256-COBLF9K8thRROJJGeg4wxqrjB3aBa4CGYkf8HdAQ2o0";
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
    maintainers = with maintainers; [ superherointj ];
  };
}
