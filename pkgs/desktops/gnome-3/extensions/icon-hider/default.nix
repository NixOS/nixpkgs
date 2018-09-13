{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-icon-hider-${version}";
  version = "20";

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = "gnome-shell-extension-icon-hider";
    rev = "v${version}";
    sha256 = "0z2rfr0nlp5zhlfxd6y0sxrxf7dj8sknimn6skxlbdm1xawl1fin";
  };

  uuid = "icon-hider@kalnitsky.org";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "Icon Hider is a GNOME Shell extension for managing status area items";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonafato ];
    platforms = platforms.linux;
    homepage = https://github.com/ikalnytskyi/gnome-shell-extension-icon-hider;
  };
}
