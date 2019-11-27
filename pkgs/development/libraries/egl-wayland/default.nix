{ lib
, stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, libX11
, mesa_glu
, wayland
, fetchpatch
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
  version = "1.1.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    sha256 = "0wvamjcfycd7rgk7v14g2rin55xin9rfkxmivyay3cm08vnl7y1d";
  };

  patches = [
    # https://github.com/NVIDIA/egl-wayland/pull/24
    (fetchpatch {
      url = "https://github.com/NVIDIA/egl-wayland/commit/1f0230f5c41722d8ec0df2828e97188ffd0a11eb.patch";
      sha256 = "16dgbm6gzaa6jx7fg9fy1sjpfhfp3r7036zri5q7kq1q02w3yhcm";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    eglexternalplatform
    libX11
    mesa_glu
    wayland
  ];

  meta = with lib; {
    description = "The EGLStream-based Wayland external platform";
    homepage = https://github.com/NVIDIA/egl-wayland/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
