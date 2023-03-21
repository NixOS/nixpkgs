{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, xfce4-panel
, libxfce4ui
, xfconf
, gitUpdater
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-notes-plugin";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-LuRAYELt01KpHhZsg7YNEyIO8E3OP6a54OsTY21jaSk=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4ui
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-notes-plugin";
    description = "Sticky notes plugin for Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
