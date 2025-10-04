{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vision-cursor";
  version = "1.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/zDyant/Vision-Cursor/releases/download/v${finalAttrs.version}/Vision-Black-Linux.tar.gz";
      hash = "sha256-Mgz00DxJ4g6JCu5D1V/O507pJN9iEGw37SzFHAc9tVY=";
    })
    (fetchurl {
      url = "https://github.com/zDyant/Vision-Cursor/releases/download/v${finalAttrs.version}/Vision-White-Linux.tar.gz";
      hash = "sha256-IYwWAyiNjosGxC5vddvnfGwtVghWOoCl0hXqxVsKDh4=";
    })

  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -R Vision-Black $out/share/icons/
    cp -R Vision-White $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Clean cursor inspired by Windows 11 style";
    homepage = "https://github.com/zDyant/Vision-Cursor";
    downloadPage = "https://github.com/zDyant/Vision-Cursor/releases";
    license = licenses.cc-by-nc-nd-40;
    maintainers = with maintainers; [ zdyant ];
  };
})
