{ stdenv, fetchurl, autoreconfHook }:

let version = "9.16";
in
stdenv.mkDerivation {
  name = "ijs-${version}";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/ghostscript-${version}.tar.bz2";
    sha256 = "0vdqbjkickb0109lk6397bb2zjmg1s46dac5p5j4gfxa4pwl8b9y";
  };

  prePatch = "cd ijs";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--disable-static" "--enable-shared" ];

  meta = with stdenv.lib; {
    homepage = https://www.openprinting.org/download/ijs/;
    description = "Raster printer driver architecture";

    license = licenses.gpl3Plus;

    platforms = platforms.all;
    maintainers = [ maintainers.abbradar ];
  };
}
