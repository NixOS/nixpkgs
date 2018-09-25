{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-icon-hider-${version}";
  version = "21";

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = "gnome-shell-extension-icon-hider";
    rev = "v${version}";
    sha256 = "0l0jb0ishaq00d4kdfvv5p7pj7b45dz57y3j2ihqr695bzb6b9hr";
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
