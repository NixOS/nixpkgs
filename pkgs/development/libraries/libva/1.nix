{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, libX11
, pkg-config
, libXext
, libdrm
, libXfixes
, wayland
, wayland-scanner
, libffi
, libGL
, mesa
, minimal ? false
, libva1-minimal
}:

stdenv.mkDerivation rec {
  pname = "libva" + lib.optionalString minimal "-minimal";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libva";
    rev = version;
    sha256 = "sha256-HTwJQpDND4PjiNpUjHtTgkQdkahm2BUe71UDRQpvo6M=";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkg-config wayland-scanner ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva1-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  # Add FHS paths for non-NixOS applications.
  configureFlags = [ "--with-drivers-path=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri" ]
    ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [ "dummy_drv_video_ladir=$(out)/lib/dri" ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/vaapi/";
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
