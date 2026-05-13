{
  lib,
  stdenv,
  fetchzip,
  glib,
  jre,
  makeWrapper,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "VASSAL";
  version = "3.7.20";

  src = fetchzip {
    url = "https://github.com/vassalengine/vassal/releases/download/${version}/${pname}-${version}-linux.tar.bz2";
    sha256 = "sha256-aPJgZGRbP016w8riqIVOYnH90QvRs4hnsEdbCVJmLZc=";
  };

  buildInputs = [
    glib
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/vassal $out/doc

    cp CHANGES LICENSE README.md $out
    cp -R lib/* $out/share/vassal
    cp -R doc/* $out/doc

    makeWrapper ${jre}/bin/java $out/bin/vassal \
      --add-flags "-Duser.dir=$out -cp $out/share/vassal/Vengine.jar \
      VASSAL.launch.ModuleManager"

    install -Dm444 -t "$out/share/icons/hicolor/scalable/apps/" VASSAL.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "VASSAL";
      exec = "vassal";
      icon = "VASSAL";
      desktopName = "VASSAL";
      comment = "The open-source boardgame engine";
      categories = [ "Game" ];
      startupWMClass = "VASSAL-launch-ModuleManager";
    })
  ];

  # Don't move doc to share/, VASSAL expects it to be in the root
  forceShare = [
    "man"
    "info"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/vassal";

  meta = {
    description = "Free, open-source boardgame engine";
    homepage = "https://vassalengine.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ tvestelind ];
    platforms = with lib.platforms; unix ++ windows;
    mainProgram = "vassal";
  };
}
