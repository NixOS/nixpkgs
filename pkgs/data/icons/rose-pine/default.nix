{
  stdenv,
  lib,
  fetchFromGitHub,
}:
  stdenv.mkDerivation rec {
    pname = "rose-pine-icon-theme";
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
      mv icons/rose-pine-icons $out/share/icons/rose-pine
      mv icons/rose-pine-dawn-icons $out/share/icons/rose-pine-dawn
      mv icons/rose-pine-moon-icons $out/share/icons/rose-pine-moon

      runHook postInstall
    '';

    meta = with lib; {
      description = "Rosé Pine icon theme for GTK";
      homepage = "https://github.com/rose-pine/gtk";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [romildo the-argus];
    };
  }
