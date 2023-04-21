{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

let
  eglexternalplatform = stdenv.mkDerivation {
    pname = "eglexternalplatform";
    version = "1.1";

    src = fetchFromGitHub {
      owner = "Nvidia";
      repo = "eglexternalplatform";
      rev = "7c8f8e2218e46b1a4aa9538520919747f1184d86";
      sha256 = "0lr5s2xa1zn220ghmbsiwgmx77l156wk54c7hybia0xpr9yr2nhb";
    };

    installPhase = ''
      mkdir -p "$out/include/"
      cp interface/eglexternalplatform.h "$out/include/"
      cp interface/eglexternalplatformversion.h "$out/include/"

      substituteInPlace eglexternalplatform.pc \
        --replace "/usr/include/EGL" "$out/include"
      mkdir -p "$out/share/pkgconfig"
      cp eglexternalplatform.pc "$out/share/pkgconfig/"
    '';

    meta = with lib; {
      license = licenses.mit;
    };
  };

in stdenv.mkDerivation rec {
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
    libdrm
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
