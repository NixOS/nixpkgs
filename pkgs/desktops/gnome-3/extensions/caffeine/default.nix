{ stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-caffeine-${version}";
  version = "unstable-2018-09-25";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "71b6392c53e063563602c3d919c0ec6a4c5c9733";
    sha256 = "170zyxa41hvyi463as650nw3ygr297901inr3xslrhvjq1qacxri";
  };

  uuid = "caffeine@patapon.info";

  nativeBuildInputs = [
    glib gettext
  ];

  buildPhase = ''
    ${bash}/bin/bash ./update-locale.sh
    glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "Fill the cup to inhibit auto suspend and screensaver";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = https://github.com/eonpatapon/gnome-shell-extension-caffeine;
  };
}
