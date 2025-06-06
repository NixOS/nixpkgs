{ lib, stdenv, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "libcxxrt";
  version = "4.0.10-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "libcxxrt";
    repo = "libcxxrt";
    rev = "c62fe9963148f283b2fbb7eb9888785cfb16d77c";
    sha256 = "XxXH6pE2v6WTh1ATJ7Fgd3SFw49L44YchtMlPKX4kYw=";
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
