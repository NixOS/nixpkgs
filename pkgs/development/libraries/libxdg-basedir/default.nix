{stdenv, fetchurl, fetchpatch}:

stdenv.mkDerivation rec {
  name = "libxdg-basedir-1.2.0";
  src = fetchurl {
    url = "https://nevill.ch/libxdg-basedir/downloads/${name}.tar.gz";
    sha256 = "2757a949618742d80ac59ee2f0d946adc6e71576406cdf798e6ced507708cdf4";
  };

  patches = [
    # Overflow bug
    (fetchpatch {
      url = "https://github.com/devnev/libxdg-basedir/commit/14e000f696ef8b83264b0ca4407669bdb365fb23.patch";
      sha256 = "0lpy1ijir0x0hhb0fz0w5vxy1wl1cw9kkd6gva0rkp41i6vrp2wq";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/devnev/libxdg-basedir";
    description = "Implementation of the XDG Base Directory specification";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
