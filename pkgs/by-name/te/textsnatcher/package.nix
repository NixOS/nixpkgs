{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, wrapGAppsHook
, pkg-config
, pantheon
, libhandy
, libportal
, glib
, gtk3
, desktop-file-utils
, scrot
, tesseract
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textsnatcher";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "RajSolai";
    repo = "TextSnatcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-phqtPjwKB5BoCpL+cMeHvRLL76ZxQ5T74cpAsgN+/JM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.granite
    libhandy
    libportal
    gtk3
    glib
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ scrot tesseract ]}
    )
  '';

  meta = with lib; {
    description = "Copy Text from Images with ease, Perform OCR operations in seconds";
    homepage = "https://textsnatcher.rf.gd/";
    changelog = "https://github.com/RajSolai/TextSnatcher/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ galaxy ];
    mainProgram = "com.github.rajsolai.textsnatcher";
    platforms = platforms.linux;
  };
})
