{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-system-monitor-${version}";
  version = "8b31f070e9e59109d729661ced313d6a63e31787";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = version;
    sha256 = "0fm5zb6qp53jjy2mnkb8ybxygzjwpb314giiq0ywq87hhrpch8m3";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    ${glib.dev}/bin/glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
  '';

  installPhase = ''
    cp -r ${uuid} $out
  '';

  uuid = "system-monitor@paradoxxx.zero.gmail.com";

  meta = with stdenv.lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aneeshusa ];
    homepage = https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet;
  };
}
