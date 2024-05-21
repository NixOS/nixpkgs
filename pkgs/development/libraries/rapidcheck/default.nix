{ lib
, stdenv
, fetchFromGitHub
, cmake
, unstableGitUpdater
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcheck";
  version = "0-unstable-2023-12-14";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = "rapidcheck";
    rev   = "ff6af6fc683159deb51c543b065eba14dfcf329b";
    hash = "sha256-Ixz5RpY0n8Un/Pv4XoTfbs40+70iyMbkQUjDqoLaWOg=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "RC_INSTALL_ALL_EXTRAS" true)
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    pkgConfigModules = [
      "rapidcheck"
      # Extras
      "rapidcheck_boost"
      "rapidcheck_boost_test"
      "rapidcheck_catch"
      "rapidcheck_doctest"
      "rapidcheck_gtest"
    ];
    platforms = platforms.all;
  };
})
