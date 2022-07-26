{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, python3
, gnome
, wrapGAppsNoGuiHook
, gobject-introspection
}:

let
  inherit (python3.pkgs) buildPythonApplication pygobject3;
in
buildPythonApplication rec {
  pname = "gnome-browser-connector";
  version = "42.0";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "nE0sIghT";
    repo = "gnome-browser-connector";
    rev = "v${version}";
    sha256 = "pYbV/qCmSrM2nrrKxbxHnJYMDOiW0aeNbFlsm5kKWdk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsNoGuiHook
    gobject-introspection # for setup-hook
  ];

  buildInputs = [
    gnome.gnome-shell
    gobject-introspection # for Gio typelib
  ];

  pythonPath = [
    pygobject3
  ];

  postPatch = ''
    patchShebangs contrib/merge_json.py
  '';

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Native host connector for the GNOME Shell browser extension";
    homepage = "https://wiki.gnome.org/Projects/GnomeShellIntegration";
    longDescription = ''
      To use the integration, install the <link xlink:href="https://wiki.gnome.org/Projects/GnomeShellIntegration/Installation">browser extension</link>, and then set <option>services.gnome.gnome-browser-connector.enable</option> to <literal>true</literal>.
    '';
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
