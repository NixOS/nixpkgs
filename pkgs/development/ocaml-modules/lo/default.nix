{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  liblo,
}:

buildDunePackage rec {
  pname = "lo";
  version = "0.2.0-unstable-2024-07-24";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lo";
    rev = "0b43bdf113c7e2c27d55c6a5f81f2fa4b30b5454";
    sha256 = "sha256-5LjhxwwE0mDZH7hcStzpV68QP2E84k1vL9e5UezeKIE=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ liblo ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lo";
    description = "Bindings for LO library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
