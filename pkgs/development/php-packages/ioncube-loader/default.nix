{
  stdenv,
  lib,
  fetchurl,
  php,
}:

let
  source =
    {
      "aarch64-darwin" = {
        url = "https://web.archive.org/web/20250614103627/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_dar_arm64.tar.gz";
        sha256 = "sha256-Dji4PIX5GqU6mOC7ZrSEu3dAZtsiVVuvKQ9Z5aGiuQ4=";
      };
      "aarch64-linux" = {
        url = "https://web.archive.org/web/20250614103715/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz";
        sha256 = "sha256-zushkH7g3L62bDdjgTZamWcxOp35xQisOjSG6e2EEHg=";
      };
      "x86_64-linux" = {
        url = "https://web.archive.org/web/20250614103238/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz";
        sha256 = "sha256-W8AXulfQx2nkT9nznCCx2lrayKA3R+n2TyhU1ScNjMg=";
      };
    }
    .${stdenv.hostPlatform.system};

  phpVersion = lib.versions.majorMinor php.version;
  systemPrefix = lib.substring 0 3 stdenv.hostPlatform.parsed.kernel.name; # lin, dar, fre

  filename = "ioncube_loader_${systemPrefix}_${phpVersion}${lib.optionalString php.ztsSupport "_ts"}.so";
in
stdenv.mkDerivation {
  pname = "ioncube-loader";
  version = "14.4.1";

  extensionName = "ioncube-loader";

  src = fetchurl source;

  installPhase = ''
    runHook preInstall
    install -Dm755 '${filename}' $out/lib/php/extensions/ioncube-loader.so
    runHook postInstall
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
      "aarch64-darwin"
    ];
  };
}
