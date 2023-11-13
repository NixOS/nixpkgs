{ lib, fetchFromGitHub, buildDunePackage, async, cohttp_static_handler ? null
, core_unix ? null, owee, ppx_jane, shell ? null }:

buildDunePackage rec {
  pname = "magic-trace";
  version = "1.1.0";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "magic-trace";
    rev = "v${version}";
    sha256 = "sha256-615AOkrbQI6vRosA5Kz3Epipe9f9+Gs9+g3bVl5gzBY=";
  };

  buildInputs = [ async cohttp_static_handler core_unix owee ppx_jane shell ];

  meta = with lib; {
    description =
      "Collects and displays high-resolution traces of what a process is doing";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/janestreet/magic-trace";
  };
}
