{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-battery-status-${version}";
  version = "6";

  src = fetchFromGitHub {
    owner = "milliburn";
    repo = "gnome-shell-extension-battery_status";
    rev = "v${version}";
    sha256 = "1w83h863mzffjnmk322xq90qf3y9dzay1w9yw5r0qnbsq1ljl8p4";
  };

  uuid = "battery_status@milliburn.github.com";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/
  '';

  meta = with stdenv.lib; {
    description = "Configurable lightweight battery charge indicator and autohider";
    license = licenses.gpl2;
    broken = true; # not compatable with latest GNOME
    maintainers = with maintainers; [ jonafato ];
    homepage = https://github.com/milliburn/gnome-shell-extension-battery_status;
  };
}
