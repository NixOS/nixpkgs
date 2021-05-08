{ stdenv, lib, fetchFromGitHub, fetchpatch, meson, pkg-config, ninja, wayland
, libdrm
, minimal ? false, libva-minimal
, libX11, libXext, libXfixes, libffi, libGL
, mesa
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString minimal "minimal-"}${version}";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva";
    rev    = version;
    sha256 = "0qk30p53mnwiqh2x68vyif11vg3gyjvw8v4qihg099m41qb44hws";
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
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.unix;
  };
}
