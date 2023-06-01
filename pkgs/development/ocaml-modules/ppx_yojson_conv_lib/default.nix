{ lib, buildDunePackage, fetchFromGitHub, yojson }:

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
  version = "0.16.0";

  minimalOCamlVersion = "4.02.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TOf6DKyvc+RsSWsLi//LXW+J0sd5uJtF/HFQllcL7No=";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
