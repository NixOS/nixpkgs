{
  lib,
  fetchFromGitHub,
  flutter332,
  gst_all_1,
  libunwind,
  orc,
  libayatana-appindicator,
  libnotify,
}:

flutter332.buildFlutterApplication rec {
  pname = "whph";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "ahmet-cetinkaya";
    repo = "whph";
    tag = "v${version}";
    hash = "sha256-ij2Rr+JFTNGsRjE09JpbxOf5kJVDN7zatKTNZrV3214=";
    fetchSubmodules = true;
    # Remove the large but useless submodule
    postFetch = "rm -rf $out/src/android";
  };

  sourceRoot = "${src.name}/src";

  pubspecLock = lib.importJSON ./pubspec.json;

  postPatch = ''
    # Don't install .desktop file to user dir
    sed -i -e '/setupEnvironment/d' lib/presentation/ui/shared/services/platform_initialization_service.dart
  '';

  buildInputs =
    (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ])
    ++ [
      libunwind
      orc
      libayatana-appindicator
      libnotify
    ];

  postInstall = ''
    # substituteInPlace $out/share/applications/whph.desktop --replace-fail $\{ICON_PATH\} whph
    mv $out/app/whph/share/icons $out/share
  '';

  meta = {
    description = "Comprehensive productivity app designed to help you manage tasks, develop new habits, and optimize your time";
    homepage = "https://whph.ahmetcetinkaya.me/";
    license = lib.licenses.gpl3Only;
    mainProgram = "whph";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ linsui ];
  };
}
