{ lib, ppx_js_style, buildDunePackage, fetchFromGitHub, yojson }:

let params =
  if lib.versionAtLeast ppx_js_style.version "0.16" then {
    version = "0.16.0";
    hash = "sha256-TOf6DKyvc+RsSWsLi//LXW+J0sd5uJtF/HFQllcL7No=";
    minimalOCamlVersion = "4.14";
  } else {
    version = "0.15.0";
    hash = "sha256-Hpg4AKAe7Q5P5UkBpH+5l1nZbIVA2Dr1Q30D4zkrjGo=";
    minimalOCamlVersion = "4.08";
  };

in

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
  inherit (params) version minimalOCamlVersion;

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    inherit (params) hash;
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}

