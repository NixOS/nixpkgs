{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

# NOTE:
#
# In order to use the qogir sddm theme, the packages
# kdePackages.plasma-desktop and kdePackages.qtsvg should be added to
# the option services.displayManager.sddm.extraPackages of the sddm
# module:
#
# environment.systemPackages = with pkgs; [
#   qogir-kde
# ];
#
# services.displayManager.sddm = {
#     enable = true;
#     package = pkgs.kdePackages.sddm;
#     theme = "Qogir";
#     extraPackages = with pkgs; [
#       kdePackages.plasma-desktop
#       kdePackages.qtsvg
#     ];
# };

stdenvNoCC.mkDerivation rec {
  pname = "qogir-kde";
  version = "0-unstable-2024-12-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "31e7bbf94e905ef40d262d2bc6063156df252470";
    hash = "sha256-zgXwYmpD31vs2Gyg21m0MdOkwqzSn6V21Kva+nvNeVI=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share

    substituteInPlace sddm/*/Main.qml \
      --replace /usr $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids

    name= HOME="$TMPDIR" ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Qogir $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Qogir-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
