{ stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-caffeine-${version}";
  version = "unstable-2019-04-02";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "a6b37dee108cddf50a0f0a19f0101854a75bf173";
    sha256 = "1j3q12j36v97551sjb0c8qc8zr7a7gmxibygczryfdfmwjzp6icl";
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
