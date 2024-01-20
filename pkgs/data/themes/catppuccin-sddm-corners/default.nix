{
  lib
, stdenvNoCC
, fetchFromGitHub
, plasma5Packages
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm-corners";
  version = "unstable-2023-02-17";

  src = fetchFromGitHub {
    owner = "khaneliman";
    repo = "catppuccin-sddm-corners";
    rev = "7b7a86ee9a5a2905e7e6623d2af5922ce890ef79";
    hash = "sha256-sTnt8RarNXz3RmYfmx4rD+nMlY8rr2n0EN3ntPzOurw=";
  };

  # Might also need qt-svg, qt-quickcontrols2
  propagatedBuildInputs = [
    plasma5Packages.qtgraphicaleffects
  ];

  dontConfigure = true;
  #dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    cp -r catppuccin/ "$out/share/sddm/themes/catppuccin-sddm-corners"

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${plasma5Packages.qtgraphicaleffects}  >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Soothing pastel theme for SDDM based on corners theme.";
    homepage = "https://github.com/khaneliman/sddm-catppuccin-corners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [khaneliman];
    platforms = lib.platforms.linux;
  };
}
