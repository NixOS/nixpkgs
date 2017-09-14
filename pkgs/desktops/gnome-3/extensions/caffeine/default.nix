{ stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-caffeine-${version}";
  version = "unstable-2017-06-21";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "ce0d0d4d3a9fed4b35b82cf59609a00502862271";
    sha256 = "01gf9c8nhhm78iakqf30900y6lywxks1pm5h2cs0jvp8d3ygd7sd";
  };

  uuid = "caffeine@patapon.info";

  nativeBuildInputs = [
    glib gettext
  ];

  buildPhase = ''
    ${bash}/bin/bash ./update-locale.sh
    ${glib.dev}/bin/glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
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
