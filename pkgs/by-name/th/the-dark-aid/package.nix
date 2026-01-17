{
  autoPatchelfHook,
  lib,
  makeWrapper,
  pcre2,
  qt5,
  requireFile,
  stdenv,
}:
let
  qtVersion = lib.versions.majorMinor qt5.qtbase.version;
in
stdenv.mkDerivation rec {
  name = "the-dark-aid";
  version = "15";

  src = requireFile rec {
    name = "419450-thedarkaid_${version}_linux_qt${qtVersion}.tar.gz";
    hash = "sha256-r+2GP3JcUM6DISGyCk+p8izxfwbZpL5nTpLwgwHMLuo=";

    message = ''
      Unfortunately, we cannot download file ${name} automatically, as it is not redistributable.
      Please go to ${meta.downloadPage} to download it yourself, and add it to the Nix store
      using

        nix-prefetch-url --type sha256 file:///path/to/${name}

      Then re-run the installation.
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    qt5.qtbase
  ];

  preferLocalBuild = true; # Because of having to manually download the sources

  installPhase = ''
    mkdir --parents "$out/opt/thedarkaid"
    cp --recursive . "$out/opt/thedarkaid"
  '';

  postFixup = ''
    makeWrapper "$out/opt/thedarkaid/thedarkaid" "$out/bin/thedarkaid" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath propagatedBuildInputs}:$out/opt/thedarkaid" \
  '';

  meta = {
    description = "Character generator for The Dark Eye 5th Edition";
    homepage = "https://www.ulisses-ebooks.de/product/309175";
    downloadPage = "https://www.ulisses-ebooks.de/product/309175";
    mainProgram = "thedarkaid";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ l0b0 ];
  };
}
