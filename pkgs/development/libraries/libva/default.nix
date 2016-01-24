{ stdenv, fetchurl, libX11, pkgconfig, libXext, libdrm, libXfixes, wayland, libffi
, mesa ? null
}:

let
  driverLink = "/run/opengl-driver" + stdenv.lib.optionalString stdenv.isi686 "-32";
in stdenv.mkDerivation rec {
  name = "libva-1.6.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0bjfb5s8dk3lql843l91ffxzlq47isqks5sj19cxh7j3nhzw58kz";
  };

  buildInputs = [ libX11 libXext pkgconfig libdrm libXfixes wayland libffi mesa ];

  configureFlags = [ "--with-drivers-path=${driverLink}/lib/dri" ]
                   ++ stdenv.lib.optional (mesa != null) "--enable-glx";

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/run/opengl-driver*/* $out
    cp -r $out/$out/* $out
    rm -rf $out/run $out/$(echo "$out" | cut -d "/" -f2)
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
  };
}
