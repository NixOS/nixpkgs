{ stdenv
, lib
, fetchFromGitHub
, glib
, gettext
, sassc
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dash-to-dock";
  version = "73";

  # Temporarily switched to commit hash because stable version is buggy.
  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "extensions.gnome.org-v${version}";
    sha256 = "/NOJWjotfYPujS5G7/zv1OLzfSW0MB+oIRsx9/LSEdA=";
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

    updateScript = gitUpdater {
      rev-prefix = "extensions.gnome.org-v";
    };
  };

  meta = with lib; {
    description = "A dock for the Gnome Shell";
    homepage = "https://micheleg.github.io/dash-to-dock/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eperuffo jtojnar rhoriguchi ];
  };
}
