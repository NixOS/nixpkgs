{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libeatmydata-65";
  
  src = fetchurl {
    url = "http://www.flamingspork.com/projects/libeatmydata/${name}.tar.gz";
    sha256 = "1hfmd24ps5661zbbw1qqgqs6hcwx6ll2fxz2j4cfvkmf0kzw25la";
  };

  meta = {
    homepage = http://www.flamingspork.com/projects/libeatmydata/;
    license = "GPLv3+";
    description = "Small LD_PRELOAD library to disable fsync and friends";
  };
}
