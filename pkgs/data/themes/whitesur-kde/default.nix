{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

# NOTE:
#
# In order to use the whitesur sddm themes, the packages
# kdePackages.plasma-desktop and kdePackages.qtsvg should be added to
# the option services.displayManager.sddm.extraPackages of the sddm
# module:
#
# environment.systemPackages = with pkgs; [
#   whitesur-kde
# ];
#
# services.displayManager.sddm = {
#     enable = true;
#     package = pkgs.kdePackages.sddm;
#     theme = "WhiteSur-dark";
#     extraPackages = with pkgs; [
#       kdePackages.plasma-desktop
#       kdePackages.qtsvg
#     ];
# };

stdenvNoCC.mkDerivation {
  pname = "whitesur-kde";
  version = "2022-05-01-unstable-2024-11-01";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "whitesur-kde";
    rev = "efba411e11f8f4d3219bffb393d25afae62eacf2";
    hash = "sha256-052mKpf8e5pSecMzaWB3McOZ/uAqp/XGJjcVWnlKPLE=";
  };

  postPatch = ''
    patchShebangs install.sh sddm/install.sh

    substituteInPlace install.sh \
      --replace-fail '[ "$UID" -eq "$ROOT_UID" ]' true \
      --replace-fail /usr $out \
      --replace-fail '"$HOME"/.Xresources' $out/doc/.Xresources

    substituteInPlace sddm/install.sh \
      --replace-fail '[ "$UID" -eq "$ROOT_UID" ]' true \
      --replace-fail /usr $out \
      --replace-fail 'REO_DIR="$(cd $(dirname $0) && pwd)"' 'REO_DIR=sddm'

    substituteInPlace sddm/*/Main.qml \
      --replace-fail /usr $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/doc
    name= ./install.sh

    mkdir -p $out/share/sddm/themes
    sddm/install.sh

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "MacOS big sur like theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/WhiteSur-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
