{ lib, stdenv, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "unstable-2022-08-08";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "a0f7f5c139a7daf71de0de201b6c405d852b1dc1";
    sha256 = "6ErOhlD6pOudbTkFTlI2hjBuYT3QuzEiL33/mLnw1aI=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp ../src/cxxabi.h $out/include
    cp lib/libcxxrt${stdenv.hostPlatform.extensions.library} $out/lib
  '';

  passthru = {
    libName = "cxxrt";
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    homepage = "https://github.com/libcxxrt/libcxxrt";
    description = "Implementation of the Code Sourcery C++ ABI";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
    license = licenses.bsd2;
  };
}
