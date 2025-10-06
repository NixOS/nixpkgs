{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  freetype,
  libglvnd,
  curl,
  libXcursor,
  libXinerama,
  libXrandr,
  libXrender,
  libjack2,
}:

stdenv.mkDerivation rec {
  pname = "tonelib-gfx";
  version = "4.8.7";

  # It's hard to find out when a release happens and what version that release is,
  #  without visiting the site directly.
  #
  # The following command can retrieve the latest released version.
  # curl --silent https://tonelib.net/downloads.html | \
  #     grep -P 'ToneLib GFX</h3' -A3 | \
  #     sed -nE 's/^.*Version: ([0-9.]+).*/\1/p'
  #
  # The following command gives us the URL for the latest release without intermediate redirects.
  # curl --head 'https://www.tonelib.net/download.php?id=gfx&os=lnx'
  src = fetchurl {
    url = "https://tonelib.vip/download/24-10-24/ToneLib-GFX-amd64.deb";
    hash = "sha256-2ao6tTRbPMpE2Y/7/gwQN3G5Z6Uu+SQel9o1ejwD9v4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    freetype
    libglvnd
  ]
  ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    curl
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libjack2
  ];

  unpackCmd = "dpkg -x $curSrc source";

  installPhase = ''
    mv usr $out
    substituteInPlace $out/share/applications/ToneLib-GFX.desktop --replace /usr/ $out/
  '';

  meta = with lib; {
    description = "Tonelib GFX is an amp and effects modeling software for electric guitar and bass";
    homepage = "https://tonelib.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      husjon
      orivej
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-GFX";
  };
}
