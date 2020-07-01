{ stdenv, lib, fetchFromGitHub, fetchpatch, meson, pkg-config, ninja, wayland
, libdrm
, minimal ? false, libva-minimal
, libX11, libXext, libXfixes, libffi, libGL
, mesa
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

  patches = [
    (fetchpatch { # meson: Allow for libdir and includedir to be absolute paths
      url = "https://github.com/intel/libva/commit/de902e2905abff635f3bb151718cc52caa3f669c.patch";
      sha256 = "1lpc8qzvsxnlsh9g0ab5lja204zxz8rr2p973pfihcw7dcxc3gia";
    })
  ];

  postPatch = ''
    # Remove the execute bit from all source code files
    # https://github.com/intel/libva/commit/dbd2cd635f33af1422cbc2079af0a7e68671c102
    chmod -x va/va{,_dec_av1,_trace,_vpp}.h
  '';

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
