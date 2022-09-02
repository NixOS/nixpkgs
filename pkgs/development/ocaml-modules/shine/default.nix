{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, shine }:

buildDunePackage rec {
  pname = "shine";
  version = "0.2.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-shine";
    rev = "2e1de686ea031f1056df389161ea2b721bfdb39e";
    sha256 = "0v6i4ym5zijki6ffkp2qkp00lk4fysjhmg690xscj23gwz4zx8ir";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ shine ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-shine";
    description = "Bindings to the fixed-point mp3 encoding library shine";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
