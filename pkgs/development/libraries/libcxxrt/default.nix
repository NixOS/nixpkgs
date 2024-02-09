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

  # NOTE: the libcxxrt readme advises against installing both the shared and static libraries.
  # I (@rhelmot) have noticed that various static builds fail without the static library present, due to -lcxxrt.
  # I don't know if the ecosystem will still work with only the staticlib.
  installPhase = ''
    mkdir -p $out/include $out/lib
    cp ../src/cxxabi.h $out/include
    cp lib/libcxxrt${stdenv.hostPlatform.extensions.library} $out/lib
    cp lib/libcxxrt${stdenv.hostPlatform.extensions.staticLibrary} $out/lib
    ln -s $out/lib/libcxxrt${stdenv.hostPlatform.extensions.library} $out/lib/libcxxrt${stdenv.hostPlatform.extensions.library}.1
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
