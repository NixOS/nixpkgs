{ lib, stdenv, pkg-config, fetchFromGitHub, python3, bash, vala_0_48
, dockbarx, gtk2, xfce, pythonPackages, wafHook }:

stdenv.mkDerivation rec {
  pname = "xfce4-dockbarx-plugin";
  version = "${ver}-${rev}";
  ver = "0.6";
  rev = "5213876";

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "xfce4-dockbarx-plugin";
    rev = rev;
    sha256 = "0s8bljn4ga2hj480j0jwkc0npp8szbmirmcsys791gk32iq4dasn";
  };

  pythonPath = [ dockbarx ];

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [ python3 vala_0_48 gtk2 pythonPackages.wrapPython ]
    ++ (with xfce; [ libxfce4util xfce4-panel xfconf xfce4-dev-tools ])
    ++ pythonPath;

  postPatch = ''
    substituteInPlace wscript           --replace /usr/share/            "\''${PREFIX}/share/"
    substituteInPlace src/dockbarx.vala --replace /usr/share/            $out/share/
    substituteInPlace src/dockbarx.vala --replace '/usr/bin/env python3' ${bash}/bin/bash
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/xfce4/panel/plugins" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/xuzhen/xfce4-dockbarx-plugin";
    description = "A plugins to embed DockbarX into xfce4-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
