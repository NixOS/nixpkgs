{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  pulseaudio,
}:

buildDunePackage rec {
  pname = "pulseaudio";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-pulseaudio";
    rev = "v${version}";
    sha256 = "sha256-eG2HS5g3ycDftRDyXGBwPJE7VRnLXNUgcEgNfVm//ds=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ pulseaudio ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-pulseaudio";
    description = "Bindings to Pulseaudio client library";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
