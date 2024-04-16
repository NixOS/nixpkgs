{ lib, stdenv, fetchurl, meson, ninja, pkg-config, python3
, libGLU, libepoxy, libX11, libdrm, mesa
, vaapiSupport ? true, libva
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "1.0.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/${version}/virglrenderer-${version}.tar.bz2";
    hash = "sha256-U8uPrdCPUmDuV4M/wkiFZUgUOLx6jjTz4RTRLMnZ25o=";
  };

  separateDebugInfo = true;

  buildInputs = [ libGLU libepoxy libX11 libdrm mesa ]
    ++ lib.optionals vaapiSupport [ libva ];

  nativeBuildInputs = [ meson ninja pkg-config python3 ];

  mesonFlags= [
    (lib.mesonBool "video" vaapiSupport)
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/virgl/virglrenderer.git";
      rev-prefix = "virglrenderer-";
    };
  };

  meta = with lib; {
    description = "A virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    mainProgram = "virgl_test_server";
    homepage = "https://virgil3d.github.io/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.xeji ];
  };
}
