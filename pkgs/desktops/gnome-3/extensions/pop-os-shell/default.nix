{ stdenv, fetchFromGitHub, nodePackages, glib }:

stdenv.mkDerivation rec {
  pname = "pop-os-shell";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev =  version;
    sha256 = "sha256-KOp/0R7P/iH52njr7JPDKd4fAoN88d/pfou2gWy5QPk=";
  };

  nativeBuildInputs = [ glib nodePackages.typescript ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions PLUGIN_BASE=$(out)/share/pop-shell/launcher" ];

  meta = with stdenv.lib; {
    description = "Keyboard-driven layer for GNOME Shell";
    license = licenses.gpl3Only;
    homepage = "https://github.com/pop-os/shell";
    platforms = platforms.linux;
    maintainers = with maintainers; [ remunds ];
  };
}
