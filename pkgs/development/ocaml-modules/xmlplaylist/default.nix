{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, xmlm }:

buildDunePackage rec {
  pname = "xmlplaylist";
  version = "0.1.5";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-xmlplaylist";
    rev = "v${version}";
    sha256 = "1x5lbwkr2ip00x8vyfbl8936yy79j138vx8a16ix7g9p2j5qsfcq";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-xmlplaylist";
    description = "Module to parse various RSS playlist formats";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
