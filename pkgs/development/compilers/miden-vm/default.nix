{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "miden-vm";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "vl2IkWpkCVTlxRbzABXWgmLGFdclxO5bBpj9CrMIt2M=";
  };

  cargoSha256 = "p6rceKpWuu/OGe6dmP5DK+16SQEVZSIWptcGcxgBBcU=";

  buildFeatures = [ "executable" ];
  checkFeatures = [];

  doCheck = true;

  meta = with lib; {
    description = "A STARK-based virtual machine";
    homepage = "https://polygon.technology/polygon-miden/";
    license = licenses.mit;
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
