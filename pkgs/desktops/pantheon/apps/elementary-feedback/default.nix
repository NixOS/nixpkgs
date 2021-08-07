{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, libhandy
, elementary-icon-theme
, elementary-gtk-theme
, gettext
, wrapGAppsHook
, appstream
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
  version = "6.0.0";

  repoName = "feedback";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1fh9a0nfvbrxamki9avm9by760csj2nqy4ya7wzbnqbrrvjwd3fv";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    elementary-icon-theme
    granite
    gtk3
    elementary-gtk-theme
    libgee
    libhandy
    glib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = "https://github.com/elementary/feedback";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
