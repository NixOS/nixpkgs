{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
}:

let
  pname = "wootility";
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sys = lib.splitString "-" stdenv.hostPlatform.system;
  version = "5.3.1";

  platform = if (builtins.elemAt sys 0) == "aarch64" then "arm64" else "x64";
  os = if (builtins.elemAt sys 1) == "darwin" then "mac" else "linux";

  # In case more Linux platforms are supported in the future.
  availablePlatforms = {
    x86_64-linux = "sha256-KRqXjguylH5FjV6j+ckZwXbg6Wm2y0CE9HQaoNgfyc0=";
  };

  src = fetchurl {
    url = "https://api.wooting.io/public/wootility/download?os=${os}&version=${version}&platform=${platform}";
    hash = selectSystem availablePlatforms;
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/wootility \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -Dm444 ${contents}/wootility.desktop -t $out/share/applications
      install -Dm444 ${contents}/wootility.png -t $out/share/icons
      substituteInPlace $out/share/applications/wootility.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=wootility'
    '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  __structuredAttrs = true;
  strictDeps = true;

  extraPkgs =
    pkgs: with pkgs; [
      libxkbfile
    ];

  meta = {
    homepage = "https://wooting.io/wootility";
    description = "Customization and management software for Wooting keyboards";
    platforms = builtins.attrNames availablePlatforms;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sodiboo
      returntoreality
    ];
    mainProgram = pname;
  };
}
