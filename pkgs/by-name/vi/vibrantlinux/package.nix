{ lib
, stdenv
, fetchFromGitHub
, qt5
, makeWrapper
, libvibrant
, libX11
, libXrandr
, libxcb
, linuxPackages
}:

stdenv.mkDerivation rec {
  pname = "vibrantLinux";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "libvibrant";
    repo = "vibrantLinux";
    rev = "v${version}";
    hash = "sha256-rvJiVId6221hTrfEIvVO9HTMhaZ6KY44Bu3a5MinPHI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ] ++ (with qt5; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [
    libX11
    libXrandr
    libxcb
    libvibrant
    linuxPackages.nvidia_x11.settings.libXNVCtrl
  ] ++ (with qt5; [
    qtbase
    qttools
  ]);

  postPatch = ''
    substituteInPlace vibrantLinux.pro \
      --replace '$$(PREFIX)' '$$PREFIX'
  '';

  meta = with lib; {
    description = "Tool to automate managing your screen's saturation depending on what programs are running";
    homepage = "https://github.com/libvibrant/vibrantLinux";
    license = licenses.mit;
    maintainers = with maintainers; [ unclamped ];
    platforms = platforms.linux;
    mainProgram = "vibrantLinux";
  };
}
