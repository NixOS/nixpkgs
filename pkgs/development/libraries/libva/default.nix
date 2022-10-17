{ stdenv, lib, fetchFromGitHub, meson, pkg-config, ninja, wayland-scanner
, libdrm
, minimal ? false, libva-minimal
, libX11, libXext, libXfixes, wayland, libffi, libGL
, mesa
}:

stdenv.mkDerivation rec {
  pname = "libva" + lib.optionalString minimal "-minimal";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva";
    rev    = version;
    sha256 = "sha256-NJA2FTPrhLj9+vmkBy+GcTiH57gBEQnYhZzYk3sEOBo=";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ meson pkg-config ninja wayland-scanner ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  mesonFlags = [
    # Add FHS and Debian paths for non-NixOS applications
    "-Ddriverdir=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri:/usr/lib/x86_64-linux-gnu/dri:/usr/lib/i386-linux-gnu/dri"
  ];

  meta = with lib; {
    description = "An implementation for VA-API (Video Acceleration API)";
    longDescription = ''
      VA-API is an open-source library and API specification, which provides
      access to graphics hardware acceleration capabilities for video
      processing. It consists of a main library (this package) and
      driver-specific acceleration backends for each supported hardware vendor.
    '';
    homepage = "https://01.org/linuxmedia/vaapi";
    changelog = "https://raw.githubusercontent.com/intel/libva/${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
