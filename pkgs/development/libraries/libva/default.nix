{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libXext, libdrm, libXfixes, wayland, libffi, libX11
, libGL, mesa
, minimal ? false, libva-minimal
, buildPackages
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString minimal "minimal-"}${version}";
  version = "2.7.1"; # Also update the hash for libva-utils!

  # update libva-utils and vaapiIntel as well
  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva";
    rev    = version;
    sha256 = "0ywasac7z3hwggj8szp83sbxi2naa0a3amblx64y7i1hyyrn0csq";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig wayland ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  enableParallelBuilding = true;

  configureFlags = [
    # Add FHS paths for non-NixOS applications.
    "--with-drivers-path=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri"
    "ac_cv_path_WAYLAND_SCANNER=${buildPackages.wayland}/bin/wayland-scanner"
  ] ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [
    "dummy_drv_video_ladir=$(out)/lib/dri"
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
