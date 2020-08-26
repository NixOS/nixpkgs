{ stdenv, fetchFromGitHub, pkgconfig, intltool, python3, imagemagick, libwnck, gtk2
, exo, libxfce4ui, libxfce4util, xfce4-panel, xfconf, xfce4-dev-tools, xfce }:

stdenv.mkDerivation rec {
  pname  = "xfce4-windowck-plugin";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "cedl38";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gwrbjfv4cnlsqh05h42w41z3xs15yjj6j8y9gxvvvvlgzzp4p3g";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    python3
    imagemagick
    libwnck
    gtk2
    exo
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
    xfce4-dev-tools
  ];

  preConfigure = ''
    ./autogen.sh
    patchShebangs .
  '';

  enableParallelBuilding = true;

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.gitLister src.meta.homepage;
    rev-prefix = "v";
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/xfce4-windowck-plugin";
    description = "Xfce plugins which allows to put the maximized window title and buttons on the panel";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.volth ];
  };
}
