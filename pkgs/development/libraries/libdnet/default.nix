{lib, stdenv, fetchurl, automake, autoconf, libtool}:

stdenv.mkDerivation rec {
  pname = "libdnet";
  version = "1.12";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-${version}.tgz";
    sha256 = "09mhbr8x66ykhf5581a5zjpplpjxibqzgkkpx689kybwg0wk1cw3";
  };

  nativeBuildInputs = [ automake autoconf ];
  buildInputs = [ libtool ];

  # .so endings are missing (quick and dirty fix)
  postInstall = ''
    for i in $out/lib/*; do
      ln -s $i $i.so
    done
  '';

  meta = {
    description = "Provides a simplified, portable interface to several low-level networking routines";
    homepage = "https://github.com/dugsong/libdnet";
    license = lib.licenses.bsd3;
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.linux;
  };
}
