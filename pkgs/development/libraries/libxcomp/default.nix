{ stdenv, fetchurl, autoreconfHook, libjpeg, libpng, libX11, zlib }:

stdenv.mkDerivation rec {
  name = "libxcomp-${version}";
  version = "3.5.0.33";

  src = fetchurl {
    sha256 = "17qjsd6v2ldpfmyjrkdnlq4qk05hz5l6qs54g8h0glzq43w28f74";
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  buildInputs = [ libjpeg libpng libX11 zlib ];
  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = ''
    cd nxcomp/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "NX compression library";
    homepage = http://wiki.x2go.org/doku.php/wiki:libs:nx-libs;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
