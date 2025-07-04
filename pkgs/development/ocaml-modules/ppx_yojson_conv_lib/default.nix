{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  yojson,
}:

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
  version = "0.17.0";

  minimalOCamlVersion = "4.02.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XGgpcAEemBNEagblBjpK+BiL0OUsU2JPqOq+heHbqVk=";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ ];
    license = licenses.mit;
  };
}
