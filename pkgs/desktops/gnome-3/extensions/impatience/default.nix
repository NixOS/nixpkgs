{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-impatience";
  version = "unstable-2019-09-23";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = "43e4e0a1e0eeb334a2da5224ce3ab4fdddf4f1b2";
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
    maintainers = with maintainers; [ timbertson tiramiseb ];
    homepage = http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml;
  };
}
