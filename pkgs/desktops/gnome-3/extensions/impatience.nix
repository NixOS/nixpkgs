{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-impatience-${version}";
  version = "6564c21e4caf4a6bc5fe2bf21116d7c15408d494";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gnome-shell-impatience";
    rev = version;
    sha256 = "10zyj42i07dcvaciv47qgkcs5g5n2bpc8a0m6fsimfi0442iwlcn";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    make schemas
  '';

  installPhase = ''
    cp -r impatience $out
  '';

  uuid = "impatience@gfxmonk.net";

  meta = with stdenv.lib; {
    description = "Speed up builtin gnome-shell animations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aneeshusa timbertson ];
    homepage = http://gfxmonk.net/dist/0install/gnome-shell-impatience.xml;
  };
}
