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
  version = "1.1.10";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    sha256 = "sha256-dbcEMtPnzF2t7O8YtKVUGSvJqb5WPMmmW+SyqOFnDY4=";
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
