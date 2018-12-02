{ stdenv, fetchFromGitHub, pkgconfig, xfce4-dev-tools
, gtk
, thunar-bare
, exo, libxfce4util, libxfce4ui
, xfconf, udev, libnotify, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  p_name  = "thunar-archive-plugin";
  ver_maj = "0.4";
  ver_min = "0";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchFromGitHub {
    owner = "xfce-mirror";
    repo = p_name;
    rev = "b63862f03a041c2467c18dc8828f3a63a2d00328";
    sha256 = "1793zicm00fail4iknliwy2b668j239ndxhc9hy6jarvdyp08h38";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xfce4-dev-tools
    thunar-bare
    exo gtk libxfce4util libxfce4ui
    xfconf udev libnotify hicolor-icon-theme
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  /*
    File roller `*.desktop` situation
    ---------------------------------

    For some odd reason, in nix os, gnome file-roller's desktop file has the non-standard name
    `org.gnome.FileRoller.desktop`. In order to be compatible with this odd context, create
    a `*.tap` file of the same name.

    IMPORTANT: Adapt or remove the symbolic link if the situation changes.
  */
  preFixup = ''
    pushd $out/libexec/thunar-archive-plugin > /dev/null
    ln -s ./file-roller.tap org.gnome.FileRoller.tap
    popd > /dev/null
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://foo-projects.org/~benny/projects/thunar-archive-plugin/;
    description = "Thunar plugin providing file context menus for archives";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
