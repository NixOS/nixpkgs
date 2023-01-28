{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, liblo }:

buildDunePackage rec {
  pname = "lo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lo";
    rev = "v${version}";
    sha256 = "0mi8h6f6syxjkxz493l5c3l270pvxx33pz0k3v5465wqjsnppar2";
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
