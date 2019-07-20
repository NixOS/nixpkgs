{ stdenv, pkgconfig, fetchFromGitHub, python2, bash, vala
, dockbarx, gtk2, xfce, pythonPackages, wafHook }:

stdenv.mkDerivation rec {
  ver = "0.5";
  rev = "a2dcb66";
  name = "xfce4-dockbarx-plugin-${ver}-${rev}";

  src = fetchFromGitHub {
    owner = "TiZ-EX1";
    repo = "xfce4-dockbarx-plugin";
    rev = rev;
    sha256 = "1f75iwlshnif60x0qqdqw5ffng2m4f4zp0ijkrbjz83wm73nsxfx";
  };

  pythonPath = [ dockbarx ];

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ python2 vala gtk2 pythonPackages.wrapPython ]
    ++ (with xfce; [ libxfce4util xfce4-panel xfconf xfce4-dev-tools ])
    ++ pythonPath;

  postPatch = ''
    substituteInPlace wscript           --replace /usr/share/            "\''${PREFIX}/share/"
    substituteInPlace src/dockbarx.vala --replace /usr/share/            $out/share/
    substituteInPlace src/dockbarx.vala --replace '/usr/bin/env python2' ${bash}/bin/bash
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/xfce4/panel/plugins" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/TiZ-EX1/xfce4-dockbarx-plugin;
    description = "A plugins to embed DockbarX into xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
