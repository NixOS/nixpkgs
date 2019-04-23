{ lib
, stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, libX11
, mesa
, wayland
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

    meta = {
      license = lib.licenses.mit;
    };
  };

in stdenv.mkDerivation rec {
  pname = "egl-wayland";
  version = "1.1.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = pname;
    rev = version;
    sha256 = "0hskxb5riy2bc6z9nq05as57y51gi01303wqg53cfm2d8gqwljv3";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    eglexternalplatform
  ];

  buildInputs = [
    wayland
    mesa
    libX11
  ];

  meta = {
    description = "The EGLStream-based Wayland external platform";
    homepage = https://github.com/NVIDIA/egl-wayland/;
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hedning ];
  };
}
