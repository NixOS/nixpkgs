{ stdenv, fetchurl, libX11, pkgconfig, libXext, libdrm, libXfixes, wayland, libffi
, mesa ? null
}:

stdenv.mkDerivation rec {
  name = "libva-1.6.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0n1l2mlhsvmsbs3qcphl4p6w13jnbv6s3hil8b6fj43a3afdrn9s";
  };

  buildInputs = [ libX11 libXext pkgconfig libdrm libXfixes wayland libffi mesa ];

  configureFlags = stdenv.lib.optional (mesa != null) "--enable-glx";

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
  };
}
