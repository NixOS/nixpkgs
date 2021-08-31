{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, accentColor ? "default"
}:

stdenvNoCC.mkDerivation rec {
  pname = "orchis-theme";
  version = "2021-06-25";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-j0nsw1yR1yOckXiIMtzhC3w6kvfzxQQHgwdY6l0OuXw=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/themes -t ${accentColor}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/vinceliuice/Orchis-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.fufexan ];
  };
}
