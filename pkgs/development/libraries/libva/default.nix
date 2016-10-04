{ stdenv, lib, fetchurl, libX11, pkgconfig, libXext, libdrm, libXfixes, wayland, libffi
, mesa_noglu
, minimal ? true, libva
}:

stdenv.mkDerivation rec {
  name = "libva-${version}";
  version = "1.7.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "04rczbnbi70y1ziy9ab59szi3glk9q35hshlws0bcj2ndbqirmjx";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva libX11 libXext libXfixes wayland libffi mesa_noglu ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  configureFlags =
    [ "--with-drivers-path=${mesa_noglu.driverLink}/lib/dri" ] ++
    lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [ "dummy_drv_video_ladir=$(out)/lib/dri" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
