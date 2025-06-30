{
  lib,
  fetchpatch,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  liblo,
}:

buildDunePackage rec {
  pname = "lo";
  version = "0.2.0";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-lo";
    rev = "v${version}";
    sha256 = "0mi8h6f6syxjkxz493l5c3l270pvxx33pz0k3v5465wqjsnppar2";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/savonet/ocaml-lo/commit/0b43bdf113c7e2c27d55c6a5f81f2fa4b30b5454.patch";
      hash = "sha256-Y5xewkKgTX9WIpbmVA9uA6N7KOPPhNguTWvowgoAcNU=";
    })
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ liblo ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-lo";
    description = "Bindings for LO library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
