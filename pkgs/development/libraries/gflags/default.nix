{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation
  { name = "gflags-2.2.1";
    src = fetchurl
      { url = "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz";
        sha256 = "03lxc2ah8i392kh1naq99iip34k4fpv22kwflyx3byd2ssycs9xf";
      };
    nativeBuildInputs = [ cmake ];
  }
