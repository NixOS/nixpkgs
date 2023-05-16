{ lib, buildDunePackage, fetchFromGitHub, yojson }:

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
<<<<<<< HEAD
  version = "0.16.0";

  minimalOCamlVersion = "4.02.3";
=======
  version = "0.15.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-TOf6DKyvc+RsSWsLi//LXW+J0sd5uJtF/HFQllcL7No=";
=======
    sha256 = "sha256-Hpg4AKAe7Q5P5UkBpH+5l1nZbIVA2Dr1Q30D4zkrjGo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
