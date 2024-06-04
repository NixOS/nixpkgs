{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ogg, libtheora }:

buildDunePackage rec {
  pname = "theora";
  version = "0.4.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-theora";
    rev = "v${version}";
    hash = "sha256-VN1XYqxMCO0W9tMTqSAwWKv7GErTtRZgnC2SnmmV7+k=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libtheora ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-theora";
    description = "Bindings to libtheora";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
