{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, gst_all_1
, cmake
}:
stdenv.mkDerivation rec {
  pname = "gst-plugins-viperfx";
  version = "unstable-2020-9-20";

  src = fetchFromGitHub {
    owner = "Audio4Linux";
    repo = "gst-plugin-viperfx";
    rev = "a5c1b03dfe1ab0822b717a5f9392e9f1237fdba0";
    sha256 = "sha256-0so4jV56nl3tZHuZpvtyMrpOZ4tNJ59Pyj6zbV5bJ5Y=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook3 ];

  propagatedBuildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  installPhase = ''
    runHook preInstall
    install -D libgstviperfx.so $out/lib/gstreamer-1.0/libgstviperfx.so
    install -D $src/COPYING $out/share/licenses/gst-plugins-viperfx/LICENSE
    runHook postInstall
  '';

  meta = with lib; {
    description = "ViPER FX core wrapper plug-in for GStreamer1";
    homepage = "https://github.com/Audio4Linux/gst-plugin-viperfx";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rewine ];
  };
}
