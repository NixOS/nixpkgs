{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, faad2, pkg-config }:

buildDunePackage rec {
  pname = "faad";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-faad";
    rev = "v${version}";
    sha256 = "sha256-3ayKZhgJAgsoOqn0InSrM5f3TImRHOQMtWETICo4t3o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ faad2 ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-faad";
    description = "Bindings for the faad library which provides functions for decoding AAC audio files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
