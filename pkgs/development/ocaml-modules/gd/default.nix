{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  gd,
}:

buildDunePackage rec {
  pname = "gd";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-gd";
    rev = "v${version}";
    sha256 = "sha256-78cqxVEappTybRLk7Y6vW1POvZKFIxtGNVcmkKq9GEE=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ gd ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-gd";
    description = "OCaml bindings for gd";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
