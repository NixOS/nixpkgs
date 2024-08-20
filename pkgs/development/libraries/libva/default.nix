{ stdenv, lib, fetchFromGitHub, meson, pkg-config, ninja, wayland-scanner
, libdrm
, minimal ? false
, libX11, libXext, libXfixes, wayland, libffi, libGL
, mesa
# for passthru.tests
, intel-compute-runtime
, intel-media-driver
, mpv
, intel-vaapi-driver
, vlc
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libva" + lib.optionalString minimal "-minimal";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva";
    rev    = finalAttrs.version;
    sha256 = "sha256-0eOYxyMt2M2lkhoWOhoUQgP/1LYY3QQqSF5TdRUuCbs=";
  };

  outputs = [ "dev" "out" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson pkg-config ninja ]
    ++ lib.optional (!minimal) wayland-scanner;

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libX11 libXext libXfixes wayland libffi libGL ];

  mesonFlags = lib.optionals stdenv.isLinux [
    # Add FHS and Debian paths for non-NixOS applications
    "-Ddriverdir=${mesa.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri:/usr/lib/x86_64-linux-gnu/dri:/usr/lib/i386-linux-gnu/dri"
  ];

  env = lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17") {
    NIX_LDFLAGS = "--undefined-version";
  } // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
    NIX_CFLAGS_COMPILE = "-DHAVE_SECURE_GETENV";
  };

  passthru.tests = {
    # other drivers depending on libva and selected application users.
    # Please get a confirmation from the maintainer before adding more applications.
    inherit intel-compute-runtime intel-media-driver intel-vaapi-driver mpv vlc;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Implementation for VA-API (Video Acceleration API)";
    longDescription = ''
      VA-API is an open-source library and API specification, which provides
      access to graphics hardware acceleration capabilities for video
      processing. It consists of a main library (this package) and
      driver-specific acceleration backends for each supported hardware vendor.
    '';
    homepage = "https://01.org/linuxmedia/vaapi";
    changelog = "https://raw.githubusercontent.com/intel/libva/${finalAttrs.version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    pkgConfigModules = [ "libva" "libva-drm" ] ++ lib.optionals (!minimal) [
      "libva-glx" "libva-wayland" "libva-x11"
    ];
    platforms = platforms.unix;
    badPlatforms = [
      # Mandatory libva shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
})
