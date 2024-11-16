{
  appimageTools,
  lib,
  pkgs,
  fetchurl,
  ...
}:
let
  pname = "zen";
  version = "1.0.1-a.19";

  # Fetch the Zen Browser AppImage
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-generic.AppImage";
    sha256 = "sha256-fubz5D1rKjapKbrIQ5yYuBnqn4ppvbJNgLh2Gmgl/hM=";
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
    description = "Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    mainProgram = "zen";
    maintainers = with maintainers; [ kmdtaufik ];
    platforms = [ "x86_64-linux" ];
  };
}
