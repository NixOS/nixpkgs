{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libXext, libdrm, libXfixes, wayland, libffi, libX11
, libGL
, minimal ? true, libva
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString (!minimal) "full-"}${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva";
    rev    = version;
    sha256 = "1x8rlmv5wfqjz3j87byrxb4d9vp5b4lrrin2fx254nwl3aqy15hy";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  enableParallelBuilding = true;

  configureFlags = [
    "--with-drivers-path=${libGL.driverLink}/lib/dri"
  ] ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [
    "dummy_drv_video_ladir=$(out)/lib/dri"
  ];

  meta = with stdenv.lib; {
    description = "VAAPI library: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.unix;
  };
}
