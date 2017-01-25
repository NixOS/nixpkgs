{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "javasvn-1.0.6";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://tmate.org/svn/org.tmatesoft.svn_1.0.6.standalone.zip;
    sha256 = "0l2s3jqi5clzj5jz962i7gmy8ims51ma60mm5iflsl00dwbmgrqf";
  };
  
  inherit unzip;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
