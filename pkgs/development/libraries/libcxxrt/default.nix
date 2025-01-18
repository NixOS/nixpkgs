{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "4.0.10-unstable-2024-10-30";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "6f2fdfebcd6291d763de8b17740d636f01761890";
    sha256 = "iUuIhwFg1Ys9DDoyDFTjEIlCVDdA1TACwtYXSRr5+2g=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];

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
