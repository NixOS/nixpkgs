{
  appimageTools,
  lib,
  fetchurl,
  ...
}:
let
  pname = "zen";
  version = "1.0.1-a.19";

  # Fetch the Zen Browser AppImage
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    sha256 = "sha256-qAPZ4VyVmeZLRfL0kPHF75zyrSUFHKQUSUcpYKs3jk8=";
  };

  # Extract the contents of the AppImage
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Extra installation commands for placing the desktop entry and icon files
  extraInstallCommands = ''
    # Install the .desktop file to applications directory
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications

    # Modify the .desktop file to point to the wrapped executable
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    # Copy icons to the appropriate directory
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  # Metadata for the package
  meta = with lib; {
    description = "Optimized Version of zen Browser for avx2 Supported CPU";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    mainProgram = "zen";
    maintainers = with maintainers; [ kmdtaufik ];
    platforms = [ "x86_64-linux" ];
  };
}
