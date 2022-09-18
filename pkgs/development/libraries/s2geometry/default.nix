{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, openssl, gtest, abseil-cpp }:

stdenv.mkDerivation (finalAttrs: {
  pname = "s2geometry";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VjgGcGgQlKmjUq+JU0JpyhOZ9pqwPcBUFEPGV9XoHc0=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl gtest (abseil-cpp.override { cxxStandard = "14"; }) ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "GOOGLETEST_ROOT" "${gtest.src}")
  ];

  meta = {
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Thra11 ];
    platforms = lib.platforms.unix;
  };
})
