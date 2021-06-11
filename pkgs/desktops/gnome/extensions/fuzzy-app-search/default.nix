{ lib, stdenv, fetchFromGitLab, gnome, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-fuzzy-app-search";
  version = "4.0.1";

  src = fetchFromGitLab {
    owner = "Czarlie";
    repo = "gnome-fuzzy-app-search";
    rev = "v${version}";
    sha256 = "127n3jc5d6cl0yrpjf8acdj76br97knks1wx4f6jcswkx9x47w0a";
  };

  uuid = "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com";

  nativeBuildInputs = [ glib ];

  makeFlags = [ "INSTALL_PATH=$(out)/share/gnome-shell/extensions" ];

  meta = with lib; {
    description = "Fuzzy application search results for Gnome Search";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://gitlab.com/Czarlie/gnome-fuzzy-app-search";
    broken = versionOlder gnome.gnome-shell.version "3.18";
  };
}
