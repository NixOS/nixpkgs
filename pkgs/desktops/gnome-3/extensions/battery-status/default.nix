{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-battery-status-${version}";
  version = "6";

  src = fetchFromGitHub {
    owner = "roberth-k";
    repo = "gnome-shell-extension-battery_status";
    rev = "v${version}";
    sha256 = "1w83h863mzffjnmk322xq90qf3y9dzay1w9yw5r0qnbsq1ljl8p4";
  };

  patches = [
    ./fix-versions.patch
  ];

  uuid = "battery_status@milliburn.github.com";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/
  '';

  meta = with stdenv.lib; {
    description = "Configurable lightweight battery charge indicator and autohider";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jonafato ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = https://github.com/roberth-k/gnome-shell-extension-battery_status;
  };
}
