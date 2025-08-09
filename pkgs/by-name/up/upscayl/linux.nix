{
  appimageTools,
  makeWrapper,

  pname,
  version,
  meta,
  src,
}:

let
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    makeWrapper
  ];

  extraPkgs = pkgs: [
    pkgs.vulkan-headers
    pkgs.vulkan-loader
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/{applications,pixmaps}

    cp ${appimageContents}/upscayl.desktop $out/share/applications/upscayl.desktop
    cp ${appimageContents}/upscayl.png $out/share/pixmaps/upscayl.png

    substituteInPlace $out/share/applications/upscayl.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=upscayl'

    wrapProgram $out/bin/upscayl \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

}
