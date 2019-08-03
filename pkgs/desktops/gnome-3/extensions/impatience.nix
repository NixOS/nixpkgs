{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-impatience-${version}";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "version-${version}";
    sha256 = "0kvdhlz41fjyqdgcfw6mrr9nali6wg2qwji3dvykzfi0aypljzpx";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    make schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r impatience $out/share/gnome-shell/extensions/${uuid}
  '';

  uuid = "impatience@gfxmonk.net";

  meta = with stdenv.lib; {
    description = "Speed up builtin gnome-shell animations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aneeshusa timbertson tiramiseb ];
    homepage = http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml;
  };
}
