{ lib, stdenv, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "4.0.10-unstable-2024-09-24";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "40e4fa2049930412a2c43cdf0c39b6b5aa735341";
    sha256 = "2rEbRTr8RLl8EKrDq210baCPDt9OppdL7zloNjGOZME=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" ];

  installPhase = ''
    mkdir -p $dev/include $out/lib
    cp ../src/cxxabi.h $dev/include
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
