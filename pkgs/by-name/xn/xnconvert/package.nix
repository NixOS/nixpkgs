{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  imagemagick,
  runCommand,
}:

let
  icon =
    runCommand "xnconvert-icon.png"
      {
        nativeBuildInputs = [ imagemagick ];
        src = fetchurl {
          url = "https://www.xnview.com/img/app-xnconvert-512.webp";
          hash = "sha256-le+rvthQndY3KbkPYuMGZDDcvdpvH9CIS2REP1vmDXg=";
        };
      }
      ''
        convert $src $out
      '';
  desktopItem = (
    makeDesktopItem {
      name = "xnconvert";
      desktopName = "XnConvert";
      exec = "xnconvert";
      icon = "xnconvert";
      comment = "A fast, powerful and free cross-platform batch image converter.";
      categories = [ "Graphics" ];
    }
  );
  version = "1.105.0";
in
appimageTools.wrapType2 {
  pname = "xnconvert";
  inherit version;

  src = fetchurl {
    url = "https://download.xnview.com/old_versions/XnConvert/XnConvert-${version}.glibc2.17-x86_64.AppImage";
    hash = "sha256-eWQSUVxR3G3XbwBCht6LW3t3/N668jH4UqK5OnRY0ko=";
  };

  extraPkgs = pkgs: [
    pkgs.qt5.qtbase
  ];

  extraInstallCommands = ''
    install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/xnconvert.png

    mkdir -p $out/share/applications/
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
  '';

  meta = {
    homepage = "https://www.xnview.com/en/xnconvert";
    description = "Fast, powerful and free cross-platform batch image converter";
    longDescription = ''
      XnConvert is a fast, powerful and free cross-platform batch image converter.
      It allows to automate editing of your photo collections: you can rotate,
      convert and compress your images, photos and pictures easily, and apply over
      80 actions (like resize, crop, color adjustments, filter, ...).
      All common picture and graphics formats are supported (JPEG, TIFF, PNG, GIF,
      WebP, PSD, JPEG2000, JPEG-XL, OpenEXR, camera RAW, HEIC, PDF, DNG, CR2).
      You can save and re-use your presets for another batch image conversion.
    '';
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    mainProgram = "xnconvert";
    maintainers = with lib.maintainers; [ aldenparker ];
  };
}
