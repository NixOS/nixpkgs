{
  stdenv,
  lib,
  fetchFromGitHub,
  variant ? "default",
}: let
  source-locations = {
    default = "icons/rose-pine-icons";
    moon = "icons/rose-pine-moon-icons";
    dawn = "icons/rose-pine-dawn-icons";
  };

  source-location =
    if builtins.hasAttr variant source-locations
    then source-locations.${variant}
    else abort "unknown rose-pine variant ${variant}";
in
  stdenv.mkDerivation rec {
    pname = "rose-pine-${variant}-icon-theme";
    version = "unstable-2022-09-01";

    src = fetchFromGitHub {
      owner = "rose-pine";
      repo = "gtk";
      rev = "7a4c40989fd42fd8d4a797f460c79fc4a085c304";
      sha256 = "0q74wjyrsjyym770i3sqs071bvanwmm727xzv50wk6kzvpyqgi67";
    };

    # avoid the makefile which is only for the theme maintainers
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons
      mv ${source-location} $out/share/icons/rose-pine

      runHook postInstall
    '';

    meta = with lib; {
      description = "Rosé Pine icon theme for GTK";
      homepage = "https://github.com/rose-pine/gtk";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      maintainers = [maintainers.romildo];
    };
  }
