{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libXext, libdrm, libXfixes, wayland, libffi, libX11
, libGL, mesa
, minimal ? false, libva-minimal
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString minimal "minimal-"}${version}";
  version = "2.5.0";

  # update libva-utils and vaapiIntel as well
  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva";
    rev    = version;
    sha256 = "0pys6blkh8ayxmxgfh7qrjzzcrzzn14z5d8q4a34ffqk90b6r93z";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  enableParallelBuilding = true;

  configureFlags = [
    # Add FHS paths for non-NixOS applications.
    "--with-drivers-path=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri"
  ] ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [
    "dummy_drv_video_ladir=$(out)/lib/dri"
  ];

  meta = with stdenv.lib; {
    description = "VAAPI library: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
