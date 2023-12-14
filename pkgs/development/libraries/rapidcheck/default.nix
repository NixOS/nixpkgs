{ lib
, stdenv
, fetchFromGitHub
, cmake
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "rapidcheck";
  version = "unstable-2023-12-14";

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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
