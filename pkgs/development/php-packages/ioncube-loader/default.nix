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
        url = "https://web.archive.org/web/20260428124658/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_mac_arm64.tar.gz";
        sha256 = "sha256-KzBF5ufljAjjP2V1lUJgW9Z+7G1evafV7pvfADFMkMM=";
      };
      "aarch64-linux" = {
        url = "https://web.archive.org/web/20260428121019/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz";
        sha256 = "sha256-TNw9y8dapjNdNKdW0FpY6pHBrq7oqSK1Ao5oqhy3dvs=";
      };
      "x86_64-linux" = {
        url = "https://web.archive.org/web/20260313061550/https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz";
        sha256 = "sha256-uCBEHux1R4FdC7aQa9oJJYgmwTTl3w5JQi+0KBDLZMc=";
      };
    }
    .${stdenv.hostPlatform.system};

  phpVersion = lib.versions.majorMinor php.version;
  systemPrefix =
    if stdenv.hostPlatform.isDarwin then
      "mac"
    else
      lib.substring 0 3 stdenv.hostPlatform.parsed.kernel.name; # lin, fre

  filename = "ioncube_loader_${systemPrefix}_${phpVersion}${lib.optionalString php.ztsSupport "_ts"}.so";
in
stdenv.mkDerivation {
  pname = "ioncube-loader";
  version = "15.5.0";

  extensionName = "ioncube-loader";

  src = fetchurl source;

  installPhase = ''
    runHook preInstall
    install -Dm755 '${filename}' $out/lib/php/extensions/ioncube-loader.so
    runHook postInstall
  '';

  meta = {
    description = "Use ionCube-encoded files on a web server";
    changelog = "https://www.ioncube.com/loaders.php";
    homepage = "https://www.ioncube.com";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ neverbehave ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
