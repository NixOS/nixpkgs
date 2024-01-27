{ lib
, stdenv
, fetchFromGitHub
, bash
, cmake
, dockbarx
, gobject-introspection
, keybinder3
, pkg-config
, python3Packages
, wrapGAppsHook
, xfce
}:

stdenv.mkDerivation rec {
  pname = "xfce4-dockbarx-plugin";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "xfce4-dockbarx-plugin";
    rev = "v${version}";
    sha256 = "sha256-ZxaWORqA8LiM4CzakxClg5C6AsyHrzCGydgboCrC45g=";
  };

  pythonPath = [
    dockbarx
    python3Packages.pygobject3
  ];

  nativeBuildInputs = [
    cmake
    gobject-introspection
    pkg-config
    python3Packages.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    keybinder3
    python3Packages.python
    xfce.xfce4-panel
    xfce.xfconf
  ]
  ++ pythonPath;

  postPatch = ''
    # We execute the wrapped xfce4-panel-plug directly.
    # Since argv is used for g_free() we also need to shift the indexes.
    substituteInPlace src/xfce_panel_plugin.c \
      --replace '"python3",' "" \
      --replace "g_free(argv[3]);" "g_free(argv[2]);" \
      --replace "g_free(argv[5]);" "g_free(argv[4]);"

    patchShebangs src/xfce4-dockbarx-plug.py
  '';

  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    chmod +x $out/share/dockbarx/xfce4-panel-plug
    wrapPythonProgramsIn "$out/share/dockbarx" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/xuzhen/xfce4-dockbarx-plugin";
    description = "Plugins to embed DockbarX into xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
