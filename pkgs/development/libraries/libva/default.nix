{ stdenv, lib, fetchFromGitHub, fetchpatch, meson, pkg-config, ninja, wayland
, libdrm
, minimal ? false, libva-minimal
, libX11, libXext, libXfixes, libffi, libGL
, mesa
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString minimal "minimal-"}${version}";
  version = "2.8.0"; # Also update the hash for libva-utils!

  # update libva-utils and vaapiIntel as well
  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva";
    rev    = version;
    sha256 = "190cq173jzp5rkrczi8gzbwa0y3xk253v4wd205a5ilfngm7srns";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ meson pkg-config ninja wayland ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  mesonFlags = [
    # Add FHS paths for non-NixOS applications:
    "-Ddriverdir=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri"
  ];

  meta = with stdenv.lib; {
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
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.unix;
  };
}
