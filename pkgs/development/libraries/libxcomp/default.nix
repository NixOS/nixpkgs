{ stdenv, fetchurl, autoreconfHook, libjpeg, libpng12, libX11, zlib }:

let version = "3.5.0.32"; in
stdenv.mkDerivation {
  name = "libxcomp-${version}";

  src = fetchurl {
    sha256 = "02n5bdc1jsq999agb4w6dmdj5l2wlln2lka84qz6rpswwc59zaxm";
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "NX compression library";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ libjpeg libpng12 libX11 zlib ];
  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = ''
    cd nxcomp/
  '';

  enableParallelBuilding = true;
}
