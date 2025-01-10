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

    cp ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    cp ${appimageContents}/${pname}.png $out/share/pixmaps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

}
