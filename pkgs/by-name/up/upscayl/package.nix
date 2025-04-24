{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:

let
  pname = "upscayl";
  version = "2.11.5";

  src = fetchurl {
    url = "https://github.com/upscayl/upscayl/releases/download/v${version}/upscayl-${version}-linux.AppImage";
    hash = "sha256-owxSm8t7rHM5ywJPp8sJQ5aAyNKgrbyJY6qFp78/UhM=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

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

  meta = with lib; {
    description = "Free and Open Source AI Image Upscaler";
    homepage = "https://upscayl.github.io/";
    maintainers = with maintainers; [ icy-thought ];
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    mainProgram = "upscayl";
  };
}
