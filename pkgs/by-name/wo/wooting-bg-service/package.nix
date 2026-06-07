{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  wootility,
  stdenv,
}:

let
  pname = "wooting-bg-service";

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  platform = lib.splitString "-" stdenv.hostPlatform.system;
  version = "0.4.8";

  # In case more Linux platforms are supported in the future.
  availablePlatforms = {
    x86_64-linux = "sha256-syezhx3ME5wFxLba3W6+UdrPF0DfbxCd1u+6yXCr6zI=";
  };

  src = fetchurl {
    url = "https://api.wooting.io/public/bg-service/download-installer?target=${builtins.elemAt platform 1}&arch=${builtins.elemAt platform 0}&version=v${version}";
    hash = selectSystem availablePlatforms;
  };
in

appimageTools.wrapType2 {
  inherit version pname src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm444 '${contents}/Wooting Background Service.desktop' -t $out/share/applications
      install -Dm444 '${contents}/Wooting Background Service.png' -t $out/share/icons
      install -Dm444 ${contents}/${pname}.png -t $out/share/icons
    '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  __structuredAttrs = true;
  strictDeps = true;

  extraPkgs =
    pkgs: with pkgs; [
      libxkbfile
      xdg-utils
    ];

  meta = {
    homepage = "https://wooting.io/wootility";
    description = "Wooting's background service. Provides applinking and allows access to CPU usage, battery level, Discord mute status, etc.";
    platforms = builtins.attrNames availablePlatforms;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sodiboo
      returntoreality
    ];
    mainProgram = pname;
  };
}
