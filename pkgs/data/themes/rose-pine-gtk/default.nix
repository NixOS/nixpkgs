{
  stdenv,
  fetchFromGitHub,
  lib,
  gnome-themes-extra,
  gtk-engine-murrine,
  gtk_engines
}:
  stdenv.mkDerivation rec {
    pname = "rose-pine-${variant}-gtk-theme";
    version = "unstable-2022-09-01";

    src = fetchFromGitHub {
      owner = "rose-pine";
      repo = "gtk";
      rev = "7a4c40989fd42fd8d4a797f460c79fc4a085c304";
      sha256 = "0q74wjyrsjyym770i3sqs071bvanwmm727xzv50wk6kzvpyqgi67";
    };

    buildInputs = [
      gnome-themes-extra # adwaita engine for Gtk2
      gtk_engines # pixmap engine for Gtk2
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine # murrine engine for Gtk2
    ];

    # avoid the makefile which is only for theme maintainers
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes
      mv gtk3/rose-pine-gtk $out/share/themes/rose-pine
      mv gtk3/rose-pine-moon-gtk $out/share/themes/rose-pine-moon
      mv gtk3/rose-pine-dawn-gtk $out/share/themes/rose-pine-dawn
      mv gnome_shell/moon/gnome-shell $out/share/themes/rose-pine-moon

      runHook postInstall
    '';

    meta = with lib; {
      description = "Rosé Pine theme for GTK";
      homepage = "https://github.com/rose-pine/gtk";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [romildo the-argus];
    };
  }
