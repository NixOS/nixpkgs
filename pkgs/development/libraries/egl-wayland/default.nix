{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, eglexternalplatform
, pkg-config
, meson
, ninja
, wayland-scanner
, libGL
, libX11
, libdrm
, wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "egl-wayland";
  version = "1.1.11";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    sha256 = "sha256-xb0d8spr4GoGZl/8C8BoPMPN7PAlzuQV11tEJbOQQ4U=";
  };

  patches = [
    # remove after next update
    # https://github.com/NVIDIA/egl-wayland/pull/79
    (fetchpatch {
      url = "https://github.com/NVIDIA/egl-wayland/commit/13737c6af4c0a7cfef5ec9013a4382bbeb7b495c.patch";
      hash = "sha256-EEqI6iJb+uv0HkhnauYNxSzny4YapTm73PLgK8A9Km8=";
    })
  ];

  postPatch = ''
    # Declares an includedir but doesn't install any headers
    # CMake's `pkg_check_modules(NAME wayland-eglstream IMPORTED_TARGET)` considers this an error
    sed -i -e '/includedir/d' wayland-eglstream.pc.in
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libX11
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  meta = with lib; {
    description = "The EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
