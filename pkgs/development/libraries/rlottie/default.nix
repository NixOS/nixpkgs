{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "rlottie";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = "v${version}";
    sha256 = "10bxr1zf9wxl55d4cw2j02r6sgqln7mbxplhhfvhw0z92fi40kr3";
  };

  patches = [
    # Fixed build with GCC 11
    (fetchpatch {
       url = "https://github.com/Samsung/rlottie/commit/2d7b1fa2b005bba3d4b45e8ebfa632060e8a157a.patch";
       hash = "sha256-2JPsj0WiBMMu0N3NUYDrHumvPN2YS8nPq5Zwagx6UWE=";
    })
  ];

  nativeBuildInputs = [ cmake ninja pkg-config ];

  cmakeFlags = [
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) "-U__ARM_NEON__";

  meta = with lib; {
    homepage = "https://github.com/Samsung/rlottie";
    description = "A platform independent standalone c++ library for rendering vector based animations and art in realtime";
    license = with licenses; [ mit bsd3 mpl11 ftl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ CRTified ];
  };
}
