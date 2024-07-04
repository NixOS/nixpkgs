{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cereal";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HapnwM5oSNKuqoKm5x7+i2zt0sny8z8CePwobz1ITQs=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DJUST_INSTALL_CEREAL=yes" ];

  meta = {
    homepage = "https://uscilab.github.io/cereal/";
    description = "Header-only C++11 serialization library";
    changelog = "https://github.com/USCiLab/cereal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
