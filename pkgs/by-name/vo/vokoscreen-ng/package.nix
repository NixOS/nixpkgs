{
  fetchFromGitHub,
  gst_all_1,
  lib,
  libX11,
  pipewire,
  pkg-config,
  pulseaudio,
  qt6,
  stdenv,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "vokoscreen-ng";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = "refs/tags/${version}";
    hash = "sha256-efgvq/jl/ecjtINy5BdqtYRp2gxEvOsMzQVyCZ3ig+Q=";
  };

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [
    qt6.qttools
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    gst_all_1.gstreamer
    libX11
    pulseaudio
    qt6.qtbase
    qt6.qtmultimedia
    wayland
    pipewire
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  # TODO: translations don't get built by the qmake project
  preBuild = ''
    lrelease src/language/*.ts
  '';

  # upstream doesn't provide an install target
  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin vokoscreenNG
    install -Dm644 -t $out/share/applications src/applications/vokoscreenNG.desktop
    install -Dm644 -t $out/share/icons src/applications/vokoscreenNG.png

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")

    runHook postInstall
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    maintainers = with maintainers; [
      shamilton
      dietmarw
    ];
    platforms = platforms.linux;
    mainProgram = "vokoscreenNG";
  };
}
