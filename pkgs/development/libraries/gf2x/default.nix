{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "gf2x-${version}";
  version = "1.2";

  src = fetchurl {
    # find link to latest version (with file id) here: https://gforge.inria.fr/projects/gf2x/
    url = "https://gforge.inria.fr/frs/download.php/file/36934/gf2x-1.2.tar.gz";
    sha256 = "0d6vh1mxskvv3bxl6byp7gxxw3zzpkldrxnyajhnl05m0gx7yhk1";
  };

  meta = with stdenv.lib; {
    description = ''Routines for fast arithmetic in GF(2)[x]'';
    homepage = http://gf2x.gforge.inria.fr;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
