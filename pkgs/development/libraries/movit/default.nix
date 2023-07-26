{ lib
, stdenv
, fetchurl
, pkg-config
, SDL2
, fftw
, gtest
, darwin
, eigen
, libepoxy
}:

stdenv.mkDerivation rec {
  pname = "movit";
  version = "1.7.0";

  src = fetchurl {
    url = "https://movit.sesse.net/${pname}-${version}.tar.gz";
    sha256 = "sha256-I1l7k+pTdi1E33Y+zCtwIwj3b8Fzggmek4UiAIHOZhA=";
  };

  outputs = [ "out" "dev" ];

  GTEST_DIR = "${gtest.src}/googletest";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
    fftw
    gtest
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.OpenGL
    darwin.libobjc
  ];

  propagatedBuildInputs = [
    eigen
    libepoxy
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = "-framework OpenGL";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = "https://movit.sesse.net";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
