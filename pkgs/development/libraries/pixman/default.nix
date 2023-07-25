{ lib
, stdenv
, fetchurl
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
}:

stdenv.mkDerivation rec {
  pname = "pixman";
  version = "0.42.2";

  src = fetchurl {
    urls = [
      "mirror://xorg/individual/lib/${pname}-${version}.tar.gz"
      "https://cairographics.org/releases/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-6hSA762i/ZSLx1Nm98NJ4cltMpfQmj/mJibjjiNKYl4=";
  };

  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpng ];

  configureFlags = lib.optional stdenv.isAarch32 "--disable-arm-iwmmxt"
    # Disable until https://gitlab.freedesktop.org/pixman/pixman/-/issues/46 is resolved
    ++ lib.optional (stdenv.isAarch64 && !stdenv.cc.isGNU) "--disable-arm-a64-neon";

  preConfigure = ''
    # https://gitlab.freedesktop.org/pixman/pixman/-/issues/62
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 184 ? 184 : NIX_BUILD_CORES))
  '';

  doCheck = true;

  postInstall = glib.flattenInclude;

  passthru.tests = {
    inherit cairo qemu scribus tigervnc wlroots xwayland;
  };

  meta = with lib; {
    homepage = "http://pixman.org";
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
