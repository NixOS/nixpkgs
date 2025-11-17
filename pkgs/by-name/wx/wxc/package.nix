{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  libGL,
  wxGTK32,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxc";
  version = "1.0.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wxHaskell";
    repo = "wxHaskell";
    rev = "wxc-${finalAttrs.version}";
    hash = "sha256-wjby7F+Xi+H4avLGZxKJ7/LY2CJAGMIwBM7mfVzI1Bg=";
  };

  sourceRoot = finalAttrs.src.name + "/wxc";

  nativeBuildInputs = [
    cmake
    wxGTK32 # in nativeBuildInputs because of wx-config
  ];

  buildInputs = [
    libGL
  ];

  preConfigure = ''
    bash generate-version-header.sh
  '';

  meta = {
    description = "C language binding for wxWidgets";
    homepage = "https://wiki.haskell.org/WxHaskell";
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = wxGTK32.meta.platforms;
  };
})
