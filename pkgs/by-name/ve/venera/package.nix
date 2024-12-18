{
  lib,
  fetchFromGitHub,
  flutter327,
  webkitgtk_4_1,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
}:
flutter327.buildFlutterApplication rec {
  pname = "venera";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    tag = "v${version}";
    hash = "sha256-zf3KeSoMLmXdD0aEYRPN5IYy0LdMYpqOkCFDmLi2ix0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_webview_window = "sha256-15tw3gLN9e886QjBFuYP34KLD1lN8AmQYXVza5Bvs40=";
    flutter_qjs = "sha256-SvOgcZquwZ1/HWVkPVnD8Eo+jD3jjfkKsVleJpNaiV0=";
    lodepng_flutter = "sha256-bGc9uXD1EQ/19OIZmR7a/YL9w93fNWdQF5S19LSwxZw=";
    photo_view = "sha256-Z+9xgvk8YS+bgCbBW7BBY72tV6JUq2kCX5OwKFK4YPE=";
    scrollable_positioned_list = "sha256-6XmBlNxE7DEqY2LsEFtVrshn2Xt55XnmaiTq+tiPInA=";
    webdav_client = "sha256-Dz/4qW+cYGyNtK8S/abFslwQNroidgrHl7oJw3uXIqM=";
    flutter_saf = "sha256-haY4eabTwUUBTpwenK0ILKpLggrtjVQszcmlpirEeTU=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    webkitgtk_4_1
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "venera";
      exec = "venera";
      icon = "venera";
      genericName = "Venera";
      desktopName = "Venera";
      categories = [
        "Utility"
      ];
      keywords = [
        "Flutter"
        "comic"
        "images"
      ];
    })
  ];

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/venera/lib"
  '';

  postInstall = ''
    install -Dm0644 ./debian/gui/venera.png $out/share/pixmaps/venera.png
  '';

  meta = {
    description = "Comic reader that support reading local and network comics";
    homepage = "https://github.com/venera-app/venera";
    mainProgram = "venera";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
