{
  lib,
  fetchFromGitHub,
  flutterPackages-source,
  gst_all_1,
  libunwind,
  orc,
  libayatana-appindicator,
  libnotify,
}:

flutterPackages-source.v3_32.buildFlutterApplication rec {
  pname = "whph";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "ahmet-cetinkaya";
    repo = "whph";
    tag = "v${version}";
    hash = "sha256-NePIR4FwJ38CWiFuq6uJamKqTy9dRll8C9OHhLlXuZQ=";
    fetchSubmodules = true;
    # Remove the large but useless submodule
    postFetch = "rm -rf $out/src/android";
  };

  sourceRoot = "${src.name}/src";

  pubspecLock = lib.importJSON ./pubspec.json;

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

  env.NIX_CFLAGS_COMPILE = "-Wno-unused-result";

  meta = {
    description = "Comprehensive productivity app designed to help you manage tasks, develop new habits, and optimize your time";
    homepage = "https://whph.ahmetcetinkaya.me/";
    license = lib.licenses.gpl3Only;
    mainProgram = "whph";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ linsui ];
  };
}
