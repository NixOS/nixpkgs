{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libpng,
  libX11,
  libXext,
  libXi,
  libXtst,
}:

stdenv.mkDerivation rec {
  pname = "xautomation";
  version = "1.09";
  src = fetchurl {
    url = "https://www.hoopajoo.net/static/projects/xautomation-${version}.tar.gz";
    sha256 = "03azv5wpg65h40ip2kk1kdh58vix4vy1r9bihgsq59jx2rhjr3zf";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpng
    libX11
    libXext
    libXi
    libXtst
  ];

  meta = {
    homepage = "https://www.hoopajoo.net/projects/xautomation.html";
    description = "Control X from the command line for scripts, and do \"visual scraping\" to find things on the screen";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vaibhavsagar ];
    platforms = with lib.platforms; linux;
  };
}
