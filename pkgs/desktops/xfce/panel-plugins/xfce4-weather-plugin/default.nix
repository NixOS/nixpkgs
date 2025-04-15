{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  glib,
  gtk3,
  json_c,
  libxml2,
  libsoup_3,
  upower,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-weather-plugin";
  version = "0.11.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-AC0f5jkG0vOgEvPLWMzv8d+8xGZ1njbHbTsD3QHA3Fc=";
  };

  patches = [
    # Port to libsoup-3.0
    # https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/-/merge_requests/28
    (fetchpatch {
      url = "https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/-/commit/c0653a903c6f2cecdf41ac9eaeba4f4617656ffe.patch";
      hash = "sha256-wAowm4ppBSKvYwOowZbbs5pnTh9EQ9XX05lA81wtsRM=";
    })
    (fetchpatch {
      url = "https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/-/commit/279c975dc1f95bd1ce9152eee1d19122e7deb9a8.patch";
      hash = "sha256-gVfyXkE0bjBfvcQU9fDp+Gm59bD3VbAam04Jak8i31k=";
    })
  ];

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
  ];

  buildInputs = [
    glib
    gtk3
    json_c
    libxml2
    libsoup_3
    upower
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  configureFlags = [ "--enable-maintainer-mode" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
