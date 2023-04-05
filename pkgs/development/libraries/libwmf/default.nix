{ lib, stdenv, fetchFromGitHub, pkg-config
, freetype, glib, imagemagick, libjpeg, libpng, libxml2, zlib
}:

stdenv.mkDerivation rec {
  pname = "libwmf";
  version = "0.2.12";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "caolanm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i2w5hg8mbgmgabxyd48qp1gx2mhk33hgr3jqvg72k0nhkd2jhf6";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib imagemagick libpng glib freetype libjpeg libxml2 ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "WMF library from wvWare";
    homepage = "https://wvware.sourceforge.net/libwmf.html";
    downloadPage = "https://github.com/caolanm/libwmf/releases";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
