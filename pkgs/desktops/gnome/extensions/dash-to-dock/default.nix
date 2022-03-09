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
  version = "71+date=2022-02-23";

  # Temporarily switched to commit hash because stable version is buggy.
  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "6f717302747931de6bf35bc9839fb3bd946e2c2f";
    sha256 = "1J8t0R43jBbqpXyH2uVyEK+OvhrCw18WWheflqwe100=";
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
