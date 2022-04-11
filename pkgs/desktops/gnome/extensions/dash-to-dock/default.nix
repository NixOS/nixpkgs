{ stdenv
, lib
, fetchFromGitHub
, glib
, gettext
, sassc
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dash-to-dock";
  version = "71+date=2022-04-11";

  # Temporarily switched to commit hash because stable version is buggy.
  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "7d0911ed07d01189034673c7ffaf82f0aee80d28";
    sha256 = "dpaDqljJ2puzftrHva6/fzbdHZWORnuhoPjz7VYqVoI=";
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

    updateScript = unstableGitUpdater {
      stableVersion = true;
      tagPrefix = "extensions.gnome.org-v";
    };
  };

  meta = with lib; {
    description = "A dock for the Gnome Shell";
    homepage = "https://micheleg.github.io/dash-to-dock/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eperuffo jtojnar rhoriguchi ];
  };
}
