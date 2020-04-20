{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-paperwm";
  version = "36.0";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = version;
    sha256 = "1ssnabwxrns36c61ppspjkr9i3qifv08pf2jpwl7cjv3pvyn4kly";
  };

  uuid = "paperwm@hedning:matrix.org";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Tiled scrollable window management for Gnome Shell";
    homepage = "https://github.com/paperwm/PaperWM";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hedning zowoq ];
  };
}
