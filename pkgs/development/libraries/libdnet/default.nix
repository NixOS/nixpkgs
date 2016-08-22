{stdenv, fetchurl, automake, autoconf, libtool}:

stdenv.mkDerivation {
  name = "libdnet-1.12";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://libdnet.googlecode.com/files/libdnet-1.12.tgz;
    sha1 = "71302be302e84fc19b559e811951b5d600d976f8";
  };

  buildInputs = [ automake autoconf libtool ];

  # .so endings are missing (quick and dirty fix)
  postInstall = ''
    for i in $out/lib/*; do
      ln -s $i $i.so
    done
  '';

  meta = {
    description = "Provides a simplified, portable interface to several low-level networking routines";
    homepage = http://code.google.com/p/libdnet/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
