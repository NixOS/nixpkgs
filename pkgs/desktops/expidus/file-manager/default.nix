{ lib, flutter, fetchFromGitHub }:
flutter.buildFlutterApplication rec {
  pname = "expidus-file-manager";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ExpidusOS";
    repo = "file-manager";
    rev = version;
    hash = "sha256-p/bKVC1LpvVcyI3NYjQ//QL/6UutjVg649IZSmz4w9g=";
  };

  depsListFile = ./deps.json;
  vendorHash = "sha256-7d8hsqXD7oqUN8VjQczSCyqytubDRq0os8wGnOfdSvs=";

  postInstall = ''
    rm $out/bin/file_manager
    ln -s $out/app/file_manager $out/bin/expidus-file-manager

    mkdir -p $out/share/applications
    mv $out/app/data/com.expidusos.file_manager.desktop $out/share/applications

    mkdir -p $out/share/icons
    mv $out/app/data/com.expidusos.file_manager.png $out/share/icons

    mkdir -p $out/share/metainfo
    mv $out/app/data/com.expidusos.file_manager.metainfo.xml $out/share/metainfo

    substituteInPlace "$out/share/applications/com.expidusos.file_manager.desktop" \
      --replace "Exec=file_manager" "Exec=$out/bin/expidus-file-manager" \
      --replace "Icon=com.expidusos.file_manager" "Icon=$out/share/icons/com.expidusos.file_manager.png"
  '';

  meta = with lib; {
    description = "ExpidusOS File Manager";
    homepage = "https://expidusos.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ RossComputerGuy ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "expidus-file-manager";
  };
}
