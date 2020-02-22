{ stdenv, fetchFromGitHub, glib, gettext, bash, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-caffeine";
  version = "33";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "v${version}";
    sha256 = "1v74xfk7csgc4kw1fg75brmhk2aby3d453ksnmj4k8ivyxkzxmfg";
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
