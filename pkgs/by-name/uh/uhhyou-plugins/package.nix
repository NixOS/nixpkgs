{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  cairo,
  fontconfig,
  freetype,
  libxcb,
  xcbutil,
  xorg,
  xcbutilkeysyms,
  libxkbcommon,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  pango,
  gtkmm3,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhhyou-plugins";
  version = "0.67.0";
  src = fetchFromGitHub {
    owner = "ryukau";
    repo = "VSTPlugins";
    rev = "UhhyouPlugins${finalAttrs.version}";
    hash = "sha256-8YGfcnWkOQwwq6m3510GPpZu6UbDmVi3K/dOGLrAnhM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    libxcb
    xcbutil
    xorg.xcbutilcursor
    xcbutilkeysyms
    libxkbcommon
    libX11
    libXrandr
    libXinerama
    libXcursor
    pango
    gtkmm3
    sqlite
  ];

  postPatch = ''
    # see: https://github.com/ryukau/VSTPlugins/blob/master/build_instruction.md#linux-ubuntu
    patch -p1 -d lib/vst3sdk/vstgui4 < ci/linux_patch/cairographicscontext.patch
    patchShebangs lib/vst3sdk/vstgui4/vstgui/uidescription/editing/createuidescdata.sh
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    cp -r VST3/Release/*.vst3 $out/lib/vst3/

    runHook postInstall
  '';

  meta = {
    description = "Collection of VST3 audio synthesis and processing plugins.";
    homepage = "https://ryukau.github.io/VSTPlugins/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ magnetophon ];
  };
})
