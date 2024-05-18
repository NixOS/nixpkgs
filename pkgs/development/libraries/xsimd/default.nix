{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "13.0.0";
  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = finalAttrs.version;
    hash = "sha256-qElJYW5QDj3s59L3NgZj5zkhnUMzIP2mBa1sPks3/CE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=${if (finalAttrs.finalPackage.doCheck && stdenv.hostPlatform == stdenv.buildPlatform) then "ON" else "OFF"}"
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
    maintainers = with maintainers; [ tobim doronbehar ];
    platforms = platforms.all;
  };
})
