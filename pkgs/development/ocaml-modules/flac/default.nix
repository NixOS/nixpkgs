{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, flac }:

buildDunePackage rec {
  pname = "flac";
  version = "0.3.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-flac";
    rev = "v${version}";
    sha256 = "06gfbrp30sdxigzkix83y1b610ljzik6rrxmbl3ppmpx4dqlwnxa";
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
