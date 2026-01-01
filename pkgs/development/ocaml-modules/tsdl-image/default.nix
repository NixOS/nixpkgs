{
  buildDunePackage,
  dune-configurator,
  fetchFromGitHub,
  lib,
  SDL2,
  SDL2_image,
  tsdl,
}:

buildDunePackage rec {
  pname = "tsdl-image";
  version = "0.6";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = pname;
    rev = version;
    hash = "sha256-mgTFwkuFJVwJmHrzHSdNh8v4ehZIcWemK+eLqjglw5o=";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    SDL2
    SDL2_image
    tsdl
  ];

<<<<<<< HEAD
  meta = {
    description = "OCaml SDL2_image bindings to go with Tsdl";
    homepage = "https://github.com/sanette/tsdl-image";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "OCaml SDL2_image bindings to go with Tsdl";
    homepage = "https://github.com/sanette/tsdl-image";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
