{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "12.1.1";
  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = finalAttrs.version;
    hash = "sha256-ofUFieeRtpnzNv3Ad5oYwKWb2XcqQHoj601TIhydJyI=";
  };
  patches =
    [
      # Ideally, Accelerate/Accelerate.h should be used for this implementation,
      # but it doesn't work... Needs a Darwin user to debug this. We apply this
      # patch unconditionally, because the #if macros make sure it doesn't
      # interfer with the Linux implementations.
      ./fix-darwin-exp10-implementation.patch
    ]
    ++ lib.optionals stdenv.isDarwin [
      # https://github.com/xtensor-stack/xsimd/issues/807
      ./disable-test_error_gamma-test.patch
    ]
    ++ lib.optionals (stdenv.isDarwin || stdenv.hostPlatform.isMusl) [
      # - Darwin report: https://github.com/xtensor-stack/xsimd/issues/917
      # - Musl   report: https://github.com/xtensor-stack/xsimd/issues/798
      ./disable-exp10-test.patch
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      # https://github.com/xtensor-stack/xsimd/issues/798
      ./disable-polar-test.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
      # Fix suggested here: https://github.com/xtensor-stack/xsimd/issues/798#issuecomment-1356884601
      # Upstream didn't merge that from some reason.
      ./fix-atan-test.patch
    ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=${
      if (finalAttrs.finalPackage.doCheck && stdenv.hostPlatform == stdenv.buildPlatform) then
        "ON"
      else
        "OFF"
    }"
  ];

  doCheck = true;
  nativeCheckInputs = [
    doctest
  ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      tobim
      doronbehar
    ];
    platforms = platforms.all;
  };
})
