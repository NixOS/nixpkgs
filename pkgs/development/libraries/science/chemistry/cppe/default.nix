{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cppe";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "maxscheurer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-guM7+ZWDJLcAUJtPkKLvC4LYSA2eBvER7cgwPZ7FxHw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "C++ and Python library for Polarizable Embedding";
    homepage = "https://github.com/maxscheurer/cppe";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
