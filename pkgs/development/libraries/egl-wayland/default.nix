{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, wayland-scanner
, libGL
, libX11
, mesa
, wayland
, wayland-protocols
, eglexternalplatform
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
    eglexternalplatform
    libGL
    libX11
    mesa
    wayland
    wayland-protocols
  ];

  postFixup = ''
    # Doubled prefix in pc file after postbuild hook replaces includedir prefix variable with dev output path
    substituteInPlace $dev/lib/pkgconfig/wayland-eglstream.pc \
      --replace "=$dev/$dev" "=$dev" \
      --replace "Requires:" "Requires.private:"
  '';

  meta = with lib; {
    description = "The EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
