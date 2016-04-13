{ stdenv, lib, fetchurl, libX11, pkgconfig, libXext, libdrm, libXfixes, wayland, libffi
, mesa_noglu
, minimal ? true, libva
}:

stdenv.mkDerivation rec {
  name = "libva-1.6.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "1l4bij21shqbfllbxicmqgmay4v509v9hpxyyia9wm7gvsfg05y4";
  };

  outputs = [ "dev" "out" "bin" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva libX11 libXext libXfixes wayland libffi mesa_noglu ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  configureFlags = lib.optionals (!minimal) [
    "--with-drivers-path=${mesa_noglu.driverLink}/lib/dri"
    "--enable-glx"
  ];

  installFlags = [ "dummy_drv_video_ladir=$(out)/lib/dri" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
  };
}
