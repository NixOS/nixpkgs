{ lib, stdenv
, fetchFromGitHub
, glib
, gettext
, sassc
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dash-to-dock";
  version = "unstable-2021-10-03";

  # temporarily switched to commit hash because GNOME 40 version is not released yet.
  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "9605dd69fe86d4f92416299c3f62605e75827dd3";
    sha256 = "0vrkiq5z2f11gqlfyis2rsnp6j25hwsp24s21vr55qkzkfszsigg";
  };

  nativeBuildInputs = [
    glib
    gettext
    sassc
  ];

  makeFlags = [
    "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions"
  ];

  passthru = {
    extensionUuid = "dash-to-dock@micxgx.gmail.com";
    extensionPortalSlug = "dash-to-dock";
  };

  meta = with lib; {
    description = "A dock for the Gnome Shell";
    homepage = "https://micheleg.github.io/dash-to-dock/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo jtojnar ];
  };
}
