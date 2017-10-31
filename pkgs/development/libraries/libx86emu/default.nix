{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "libx86emu-${version}";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/wfeldt/libx86emu/archive/${version}.tar.gz";
    sha256 = "1im6w6m0bl6ajynx4hc028lad8v10whv4y7w9zxndzh3j4mi3aa8";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    # VERSION is usually generated using Git
    echo "${version}" > VERSION
    sed -i 's|/usr/|/|g' Makefile
  '';

  makeFlags = [ "shared" ];

  installPhase = ''
    make install DESTDIR=$out/ LIBDIR=lib
  '';

  meta = with stdenv.lib; {
    description = "x86 emulation library";
    license = licenses.bsd2;
    homepage = https://github.com/wfeldt/libx86emu;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
