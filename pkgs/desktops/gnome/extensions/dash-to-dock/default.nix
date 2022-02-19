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
  version = "71+date=2022-01-24";

  # Temporarily switched to commit hash because stable version is buggy.
  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "53114b4e000482a753e8b42dfa10d6057c08d1c6";
    sha256 = "Gv78I/dxhc6FpjZWk10uHBfD24tHE4KdkpaAo8UZpwU=";
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
