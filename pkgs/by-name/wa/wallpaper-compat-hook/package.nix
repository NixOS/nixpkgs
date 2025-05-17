{
  lib,
  makeSetupHook,
  imagemagick,
  libsForQt5,
}:

makeSetupHook {
  name = "wallpaper-compat-hook";

  propagatedBuildInputs = [
    imagemagick
    libsForQt5.kcoreaddons
  ];

  meta = {
    description = "Setup hook for ensuring wallpaper compatibility between desktop environments";
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
} ./setup-hook.sh
