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
  libxcursor,
  libxinerama,
  libxrandr,
  libxrender,
  libjack2,
  webkitgtk_4_1,
}:

stdenv.mkDerivation rec {
  pname = "tonelib-zoom";
  version = "4.3.1";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0129/ToneLib-Zoom-amd64.deb";
    sha256 = "sha256-4q2vM0/q7o/FracnO2xxnr27opqfVQoN7fsqTD9Tr/c=";
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
    webkitgtk_4_1
  ]
  ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    curl
    libxcursor
    libxinerama
    libxrandr
    libxrender
    libjack2
  ];

  unpackCmd = "dpkg -x $curSrc source";

  installPhase = ''
    mv usr $out
    substituteInPlace $out/share/applications/ToneLib-Zoom.desktop --replace /usr/ $out/

    # tonelib-zoom expects libwebkit2gtk-4.0.so.37:
    #   error: auto-patchelf could not satisfy dependency libwebkit2gtk-4.0.so.37
    #
    # webkitgtk_4_0 has been deprecated and consequently removed from nixpkgs; this package
    # works fine with webkitgtk_4_1, though, so patch it to use webkitgtk_4_1 instead
    mkdir -p $out/lib/
    ln -s ${webkitgtk_4_1}/lib/libwebkit2gtk-4.1.so.0 $out/lib/libwebkit2gtk-4.0.so.37
  '';

  meta = {
    description = "ToneLib Zoom – change and save all the settings in your Zoom(r) guitar pedal";
    homepage = "https://tonelib.net/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-Zoom";
  };
}
