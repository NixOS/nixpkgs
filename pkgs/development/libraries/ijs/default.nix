{ stdenv, fetchurl, fetchpatch, autoreconfHook }:

let version = "9.18";
in
stdenv.mkDerivation {
  name = "ijs-${version}";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/ghostscript-${version}.tar.bz2";
    sha256 = "18ad90za28dxybajqwf3y3dld87cgkx1ljllmcnc7ysspfxzbnl3";
  };

  patches = [
    # http://bugs.ghostscript.com/show_bug.cgi?id=696246
    (fetchpatch {
      name = "devijs-account-for-device-subclassing.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=b68e05c3";
      sha256 = "1c3fzfjzvf15z533vpw3l3da8wcxw98qi3p1lc6lf13940a57c7n";
    })
  ];

  postPatch = "cd ijs";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--disable-static" "--enable-shared" ];

  meta = with stdenv.lib; {
    homepage = "https://www.openprinting.org/download/ijs/";
    description = "Raster printer driver architecture";

    license = licenses.gpl3Plus;

    platforms = platforms.all;
    maintainers = [ maintainers.abbradar ];
  };
}
