{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libpng
, glib /*just passthru*/

# for passthru.tests
, cairo
, qemu
, scribus
, tigervnc
, wlroots
, xwayland

, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pixman";
  version = "0.43.0";

  src = fetchurl {
    urls = [
      "mirror://xorg/individual/lib/${pname}-${version}.tar.gz"
      "https://cairographics.org/releases/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-plwoIJhY+xa+5Q2AnID5Co5BXA5P2DIQeKGCJ4WlVgo=";
  };

  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ libpng ];

  # Default "enabled" value attempts to enable CPU features on all
  # architectures and requires used to disable them:
  #   https://gitlab.freedesktop.org/pixman/pixman/-/issues/88
  mesonAutoFeatures = "auto";
  mesonFlags = [
    "-Diwmmxt=disabled"
  ]
  # Disable until https://gitlab.freedesktop.org/pixman/pixman/-/issues/46 is resolved
  ++ lib.optional (stdenv.isAarch64 && !stdenv.cc.isGNU) "-Da64-neon=disabled";

  preConfigure = ''
    # https://gitlab.freedesktop.org/pixman/pixman/-/issues/62
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 184 ? 184 : NIX_BUILD_CORES))
  '';

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = glib.flattenInclude;

  passthru = {
    tests = {
      inherit cairo qemu scribus tigervnc wlroots xwayland;
    };
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/pixman/pixman.git";
      rev-prefix = "pixman-";
    };
  };

  meta = with lib; {
    homepage = "http://pixman.org";
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
