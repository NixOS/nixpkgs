{ lib, buildDunePackage, fetchFromGitHub, yojson }:

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
  version = "0.15.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hpg4AKAe7Q5P5UkBpH+5l1nZbIVA2Dr1Q30D4zkrjGo=";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
