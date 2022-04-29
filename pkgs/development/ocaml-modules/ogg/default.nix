{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, libogg }:

buildDunePackage rec {
  pname = "ogg";
  version = "0.7.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ogg";
    rev = "v${version}";
    sha256 = "0z3z0816rxq8wdjw51plzn8lmilic621ilk4x9wpnr0axmnl3wqb";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ogg";
    description = "Bindings to libogg";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
