{ lib, stdenv, fetchFromGitLab, gnome, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-fuzzy-app-search";
  version = "4";

  src = fetchFromGitLab {
    owner = "Czarlie";
    repo = "gnome-fuzzy-app-search";
    rev = "da9c15d39958d9c3b38df3b616fd40b85aed24e5";
    sha256 = "1r3qha530s97x818znn1wi76f4x9bhlgi7jlxfwjnrwys62cv5fn";
  };

  uuid = "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com";

  nativeBuildInputs = [ glib ];

  patches = [ ./fix-desktop-file-paths.patch ];

  makeFlags = [ "INSTALL_PATH=$(out)/share/gnome-shell/extensions" ];

  meta = with lib; {
    description = "Fuzzy application search results for Gnome Search";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://gitlab.com/Czarlie/gnome-fuzzy-app-search";
    broken = versionOlder gnome.gnome-shell.version "3.18";
  };
}
