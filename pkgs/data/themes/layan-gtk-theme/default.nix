{ stdenv
, fetchFromGitHub
, lib
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "layan-gtk-theme";
  version = "2021-06-30";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-FI8+AJlcPHGOzxN6HUKLtPGLe8JTfTQ9Az9NsvVUK7g=";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    unset name && ./install.sh -d $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A flat Material Design theme for GTK 3, GTK 2 and Gnome-Shell.";
    homepage = "https://github.com/vinceliuice/Layan-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.vanilla ];
  };
}
