{ lib
, stdenv
, fetchFromGitHub
, bash
, dockbarx
, gobject-introspection
, keybinder3
, pkg-config
, python3Packages
, vala
, wafHook
, wrapGAppsHook
, xfce
}:

stdenv.mkDerivation rec {
  pname = "xfce4-dockbarx-plugin";
  version = "${ver}-${rev}";
  ver = "0.6";
  rev = "5213876151f1836f044e9902a22d1e682144c1e0";

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "xfce4-dockbarx-plugin";
    rev = rev;
    sha256 = "sha256-VqtGcBRjvpCO9prVHOv6Gt1rAZtcAgkQkVCoR6ykC2k=";
  };

  pythonPath = [
    dockbarx
    python3Packages.pygobject3
  ];

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    python3Packages.wrapPython
    vala
    wafHook
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
    substituteInPlace wscript           --replace /usr/share/            "\''${PREFIX}/share/"
    substituteInPlace src/dockbarx.vala --replace /usr/share/            $out/share/
    substituteInPlace src/dockbarx.vala --replace '/usr/bin/env python3' ${bash}/bin/bash
  '';

  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonProgramsIn "$out/share/xfce4/panel/plugins" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/xuzhen/xfce4-dockbarx-plugin";
    description = "Plugins to embed DockbarX into xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
