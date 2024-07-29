{ stdenv, buildNpmPackage, fetchFromGitHub, electron, makeWrapper, python3, makeDesktopItem, lib }:

buildNpmPackage rec {
  pname = "vieb";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "Jelmerro";
    repo = pname;
    rev = version;
    hash = "sha256-Gx2O5KJ0N/rSTwYcA10bRjXacIUdXETd18dkGBVv8wM=";
  };

  postPatch = ''
    sed -i '/"electron"/d' package.json
  '';

  npmDepsHash = "sha256-eajM2YysFhp3eiWeJwkfpZPpte31UHrtg9rfMexefsg=";
  makeCacheWritable = true;
  dontNpmBuild = true;
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isAarch64 python3;

  desktopItem = makeDesktopItem {
    name = "vieb";
    exec = "vieb %U";
    icon = "vieb";
    desktopName = "Web Browser";
    genericName = "Web Browser";
    categories = [ "Network" "WebBrowser" ];
    mimeTypes = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  postInstall = ''
    install -Dm0644 {${desktopItem},$out}/share/applications/vieb.desktop

    pushd $out/lib/node_modules/vieb/app/img/icons
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/vieb.png
    done
    popd

    makeWrapper ${electron}/bin/electron $out/bin/vieb \
      --add-flags $out/lib/node_modules/vieb/app \
      --set npm_package_version ${version}
  '';

  distPhase = ":"; # disable useless $out/tarballs directory

  meta = with lib; {
    homepage = "https://vieb.dev/";
    changelog = "https://github.com/Jelmerro/Vieb/releases/tag/${version}";
    description = "Vim Inspired Electron Browser";
    mainProgram = "vieb";
    maintainers = with maintainers; [ gebner tejing ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
