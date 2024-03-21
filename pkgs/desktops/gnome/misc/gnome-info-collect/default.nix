{ stdenv
, lib
, fetchFromGitLab
, python3
, meson
, ninja
, accountsservice
, gnome
, gnome-online-accounts
, malcontent
, gobject-introspection
, wrapGAppsNoGuiHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-info-collect";
  version = "1.0-7";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "vstanek";
    repo = "gnome-info-collect";
    rev = "v${version}";
    sha256 = "sha256-9C1pVCOaGLz0xEd2eKuOQRu49GOLD7LnDYvgxpCgtF4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    accountsservice
    gnome.gnome-remote-desktop
    gnome.gnome-settings-daemon
    gnome.gnome-shell
    gnome.mutter
    gnome-online-accounts
    malcontent
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    requests
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/vstanek/gnome-info-collect";
    description = "Simple utility to collect system information for improving GNOME";
    maintainers = teams.gnome.members;
    license = with licenses; [
      lgpl21Only # Cambalache
      gpl2Only # tools
    ];
    platforms = platforms.unix;
  };
}
