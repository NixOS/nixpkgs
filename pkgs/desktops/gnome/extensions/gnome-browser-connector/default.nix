{ stdenv
, lib
, fetchurl
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
  version = "42.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-browser-connector/${lib.versions.major version}/gnome-browser-connector-${version}.tar.xz";
    sha256 = "vZcCzhwWNgbKMrjBPR87pugrJHz4eqxgYQtBHfFVYhI=";
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

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-browser-connector";
    };
  };

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
