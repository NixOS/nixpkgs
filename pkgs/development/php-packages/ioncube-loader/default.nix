{
  stdenv,
  lib,
  fetchzip,
  php,
}:

let
  phpVersion = lib.versions.majorMinor php.version;

  variant = {
    "aarch64-darwin" = {
      url = "https://web.archive.org/web/20240209234707/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_dar_arm64.tar.gz";
      sha256 = "sha256-J6+bOXX9uRdrGouMAxt7nROjjfH4P2txb1hmPoHUmdM=";
      prefix = "dar";
    };
    "aarch64-linux" = {
      url = "https://web.archive.org/web/20240209234617/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz";
      sha256 = "sha256-oOO4zr0CssxVGIUIfmAujILqOfQf8dJPADkr03a8HAs=";
      prefix = "lin";
    };
    "x86_64-linux" = {
      url = "https://web.archive.org/web/20240209052345if_/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz";
      sha256 = "sha256-rsXKgxKHldBKDjJTsOdJP4SxfxLmMPDY+GizBpuDeyw=";
      prefix = "lin";
    };
    "x86_64-darwin" = {
      url = "https://web.archive.org/web/20240209234406/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_mac_x86-64.tar.gz";
      sha256 = "sha256-bz2hQOaFbXePa8MhAZHESpZMRjjBH51IgvbR2EfBYMg=";
      prefix = "mac";
    };
  };
in
stdenv.mkDerivation {
  version = "13.0.2";
  pname = "ioncube-loader";
  extensionName = "ioncube-loader";

  src = fetchzip {
    url = variant.${stdenv.hostPlatform.system}.url;
    sha256 = variant.${stdenv.hostPlatform.system}.sha256;
  };

  installPhase = ''
    mkdir -p $out/lib/php/extensions
    cp $src/ioncube_loader_${
      variant.${stdenv.hostPlatform.system}.prefix
    }_${phpVersion}.so $out/lib/php/extensions/ioncube-loader.so
  '';

  meta = with lib; {
    description = "Use ionCube-encoded files on a web server";
    changelog = "https://www.ioncube.com/loaders.php";
    homepage = "https://www.ioncube.com";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ neverbehave ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
