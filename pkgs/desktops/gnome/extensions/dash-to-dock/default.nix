{ lib, stdenv
, fetchFromGitHub
, glib
, gettext
, sassc
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dash-to-dock";
  version = "unstable-2021-07-07";

  # temporarily switched to https://github.com/micheleg/dash-to-dock/pull/1402 because upstream doesn't work with GNOME 40 yet.
  src = fetchFromGitHub {
    owner = "ewlsh";
    repo = "dash-to-dock";
    rev = "e4beec847181e4163b0a99ceaef4c4582cc8ae4c";
    hash = "sha256-7UVnLXH7COnIbqxbt3CCscuu1YyPH6ax5DlKdaHCT/0=";
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
