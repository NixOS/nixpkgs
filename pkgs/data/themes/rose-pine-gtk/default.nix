{ stdenv
, fetchFromGitHub
, lib
, gnome-themes-extra
, gtk-engine-murrine
, gtk_engines
}:

stdenv.mkDerivation rec {
  pname = "rose-pine-gtk-theme";
  version = "unstable-2021-02-22";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    rev = "9cd2dd449f911973ec549231a57a070d256da9fd";
    sha256 = "0lqx8dmv754ix3xbg7h440x964n0bg4lb06vbzvsydnbx79h7lvy";
  };

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
    gtk_engines # pixmap engine for Gtk2
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine # murrine engine for Gtk2
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Rose-Pine $out/share/themes
    rm $out/share/themes/*/LICENSE
    runHook postInstall
  '';

  meta = with lib; {
    description = "Rosé Pine theme for GTK";
    homepage = "https://github.com/rose-pine/gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
