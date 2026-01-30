{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "wide-integer";
  version = "1.01";

  src = fetchFromGitHub {
    owner = "ckormanyos";
    repo = "wide-integer";
    tag = "v${version}";
    hash = "sha256-F1/bm8i5VUlKlQkYIXOmy4eUl/JcSLQ2FtdpiKxZHDw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/ckormanyos/wide-integer";
    description = "implements a generic C++ template for uint128_t, uint256_t, uint512_t, uint1024_t, etc.";
    license = with lib.licenses; [ boost ];
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
