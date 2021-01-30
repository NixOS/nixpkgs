{ lib, stdenv, fetchFromGitHub, gtk3, gnome-themes-extra, gtk-engine-murrine
, accentColor ? "default" }:

stdenv.mkDerivation rec {
  pname = "orchis";
  version = "2021-01-22";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "1m0wilvrscg2xnkp6a90j0iccxd8ywvfpza1345sc6xmml9gvjzc";
  };

  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

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
