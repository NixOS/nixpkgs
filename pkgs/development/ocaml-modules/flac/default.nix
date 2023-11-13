{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, flac }:

buildDunePackage rec {
  pname = "flac";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-flac";
    rev = "v${version}";
    sha256 = "sha256-oMmxZtphEX/OPfyTumjkWQJidAjSRqriygaTjVJTCG0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg flac.dev ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-flac";
    description = "Bindings for flac";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
