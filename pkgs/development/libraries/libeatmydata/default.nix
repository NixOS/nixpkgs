{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libeatmydata-82";
  
  src = fetchurl {
    url = "http://www.flamingspork.com/projects/libeatmydata/${name}.tar.gz";
    sha256 = "0aavq71bf0yxdgyf8gvyzq086shszzwpbsz5rqkjg4cz0rc5yrqb";
  };

  meta = {
    homepage = http://www.flamingspork.com/projects/libeatmydata/;
    license = stdenv.lib.licenses.gpl3Plus;
    description = "Small LD_PRELOAD library to disable fsync and friends";
  };
}
