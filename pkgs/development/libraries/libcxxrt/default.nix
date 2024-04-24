{ lib, stdenv, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "25541e312f7094e9c90895000d435af520d42418";
    sha256 = "d5uhtlO+28uc2Xnf5trXsy43jgmzBHs2jZhCK57qRM4=";
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
