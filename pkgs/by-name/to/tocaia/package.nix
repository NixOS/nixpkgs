{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation rec {
  pname = "tocaia";
  version = "0.9.0";

  src = fetchgit {
    url = "https://github.com/manipuladordedados/tocaia.git";
    rev = "refs/tags/${version}";
    sha256 = "sha256-Np+Awn5KGoAbeoUEkcAeVwnNCqI2Iy+19Zj1RkNfgXU=";
  };

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a tocaia $out/bin
  '';

  meta = with lib; {
    description = "Portable TUI Gopher client written in C89 for POSIX systems";
    homepage = "https://github.com/manipuladordedados/tocaia";
    license = licenses.bsd2;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.unix;
  };
}
