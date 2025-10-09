{
  lib,
  flutter,
  fetchFromGitHub,
}:
flutter.buildFlutterApplication rec {
  pname = "expidus-file-manager";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ExpidusOS";
    repo = "file-manager";
    rev = version;
    hash = "sha256-R6eszy4Dz8tAPRTwZzRiZWIgVMiGv5zlhFB/HcD6gqg=";
  };

  flutterBuildFlags = [
    "--dart-define=COMMIT_HASH=b4181b9cff18a07e958c81d8f41840d2d36a6705"
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    libtokyo = "sha256-T0+vyfSfijLv7MvM+zt3bkVpb3aVrlDnse2xyNMp9GU=";
    libtokyo_flutter = "sha256-T0+vyfSfijLv7MvM+zt3bkVpb3aVrlDnse2xyNMp9GU=";
  };

  postInstall = ''
    rm $out/bin/file_manager
    ln -s $out/app/$pname/file_manager $out/bin/expidus-file-manager

    mkdir -p $out/share/applications
    mv $out/app/$pname/data/com.expidusos.file_manager.desktop $out/share/applications

    mkdir -p $out/share/icons
    mv $out/app/$pname/data/com.expidusos.file_manager.png $out/share/icons

    mkdir -p $out/share/metainfo
    mv $out/app/$pname/data/com.expidusos.file_manager.metainfo.xml $out/share/metainfo

    substituteInPlace "$out/share/applications/com.expidusos.file_manager.desktop" \
      --replace "Exec=file_manager" "Exec=$out/bin/expidus-file-manager" \
      --replace "Icon=com.expidusos.file_manager" "Icon=$out/share/icons/com.expidusos.file_manager.png"
  '';

  meta = with lib; {
    broken = true;
    description = "ExpidusOS File Manager";
    homepage = "https://expidusos.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ RossComputerGuy ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "expidus-file-manager";
  };
}
