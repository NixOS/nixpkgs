{
  lib,
  fetchFromGitHub,
  flutter,
  webkitgtk_4_1,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
}:
flutter.buildFlutterApplication rec {
  pname = "venera";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    rev = "refs/tags/v${version}";
    hash = "sha256-+z0OXWC3Qfyjukv9TT+pHfjRKvSvJKAd0SqMWgaMtZE=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_webview_window = "sha256-15tw3gLN9e886QjBFuYP34KLD1lN8AmQYXVza5Bvs40=";
    flutter_qjs = "sha256-IeOuw2oh3WpuYQgfE77BoPU8Qukp4l8SSmZtHebKU4M=";
    flutter_to_arch = "sha256-DdP82Bdl58XW/BxMyWV3Vh4JYC2DNTjZcQB0fvw72fA=";
    lodepng_flutter = "sha256-puw+eVe/ZtzV+PTsC0WmP0YLuWu5slFY0r0v/SHyzHI=";
    photo_view = "sha256-Z+9xgvk8YS+bgCbBW7BBY72tV6JUq2kCX5OwKFK4YPE=";
    scrollable_positioned_list = "sha256-6XmBlNxE7DEqY2LsEFtVrshn2Xt55XnmaiTq+tiPInA=";
    zip_flutter = "sha256-104/tGShkLAOYw9dC/yrt/qnm0NZ+Jk7nkbt3lPcYA8=";
    webdav_client = "sha256-Dz/4qW+cYGyNtK8S/abFslwQNroidgrHl7oJw3uXIqM=";
    flutter_saf = "sha256-O0f+ItlQJyNn5d6tozStrxg7ntQFxU033AI3Aw2x8G0=";
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
      name = "Venera";
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
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib"
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
