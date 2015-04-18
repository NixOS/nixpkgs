{ stdenv, fetchurl, autoreconfHook }:

let version = "9.15";
in
stdenv.mkDerivation {
  name = "ijs-${version}";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/ghostscript-${version}.tar.bz2";
    sha256 = "0p1isp6ssfay141klirn7n9s8b546vcz6paksfmksbwy0ljsypg6";
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
