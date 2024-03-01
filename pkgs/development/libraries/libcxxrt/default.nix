{ lib, stdenv, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "bd4fa85d7f772f2ad32146d5681c91612fc93842";
    sha256 = "2F6MmLfKyFl7HzdTb1NDBVHMSRVzVhcib93JVaR58Qw=";
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
