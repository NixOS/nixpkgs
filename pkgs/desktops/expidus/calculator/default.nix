{
  lib,
  flutter,
  fetchFromGitHub,
}:
flutter.buildFlutterApplication rec {
  pname = "expidus-calculator";
  version = "0.1.1-alpha";

  src = fetchFromGitHub {
    owner = "ExpidusOS";
    repo = "calculator";
    rev = version;
    hash = "sha256-O3LHp10Fo3PW3zoN7mFSQEKh+AAaR+IqkRtc6nQrIZE=";
  };

  flutterBuildFlags = [
    "--dart-define=COMMIT_HASH=a5d8f54404b9994f83beb367a1cd11e04a6420cb"
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    libtokyo = "sha256-T0+vyfSfijLv7MvM+zt3bkVpb3aVrlDnse2xyNMp9GU=";
    libtokyo_flutter = "sha256-T0+vyfSfijLv7MvM+zt3bkVpb3aVrlDnse2xyNMp9GU=";
  };

  postInstall = ''
    rm $out/bin/calculator
    ln -s $out/app/calculator $out/bin/expidus-calculator

    mkdir -p $out/share/applications
    mv $out/app/data/com.expidusos.calculator.desktop $out/share/applications

    mkdir -p $out/share/icons
    mv $out/app/data/com.expidusos.calculator.png $out/share/icons

    mkdir -p $out/share/metainfo
    mv $out/app/data/com.expidusos.calculator.metainfo.xml $out/share/metainfo

    substituteInPlace "$out/share/applications/com.expidusos.calculator.desktop" \
      --replace "Exec=calculator" "Exec=$out/bin/expidus-calculator" \
      --replace "Icon=com.expidusos.calculator" "Icon=$out/share/icons/com.expidusos.calculator.png"
  '';

  meta = with lib; {
    description = "ExpidusOS Calculator";
    homepage = "https://expidusos.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ RossComputerGuy ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "expidus-calculator";
  };
}
