{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ctypes, ctypes-foreign, lilv }:

buildDunePackage rec {
  pname = "lilv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lilv";
    rev = "v${version}";
    sha256 = "080ja8c4sxprk5qnldpfzxriag57m9603vny3b4bnwh5xm1id08c";
  };

  minimalOCamlVersion = "4.03.0";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ctypes ctypes-foreign lilv ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lilv";
    description = "OCaml bindings for lilv";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
