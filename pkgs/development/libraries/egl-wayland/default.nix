{ lib
, stdenv
, fetchFromGitHub
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
  version = "1.1.15";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    hash = "sha256-7spfmYwJ6U97x83219/kMwdJXS2vir+U0MUnYWJOLB4=";
  };

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
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
