{ stdenv, fetchurl }:

let
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation {
  name = "aterm-2.8";

  src = fetchurl {
    url = http://www.meta-environment.org/releases/aterm-2.8.tar.gz;
    sha256 = "1vq4qpmcww3n9v7bklgp7z1yqi9gmk6hcahqjqdzc5ksa089rdms";
  };

  patches = [
    # Fix for http://bugzilla.sen.cwi.nl:8080/show_bug.cgi?id=841
    ./max-long.patch
  ] ++ ( if isMingw then [./aterm-mingw-asm.patch] else [] );

  # The test programs stress, randgen, fib, and testsafio all fail with
  # segmentation faults when compiled with GCC 4.8.x, and the code itself many
  # warnings, complaining "cast from pointer to integer of different size".
  # This looks really bad. I leave the test suite enabled, because those issue
  # feel too serious to just ignore.
  doCheck = true;

  dontStrip = isMingw;

  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = stdenv.lib.maintainers.eelco;
  };
}
