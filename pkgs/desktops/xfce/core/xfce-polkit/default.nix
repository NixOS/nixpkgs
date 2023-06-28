{ lib
, stdenv
, fetchurl
, pkg-config
, gtk3
, glib
, libxfce4ui
, polkit
}:

stdenv.mkDerivation rec {
  pname = "xfce-polkit";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/ncopa/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Vk5WaoPC3V/CGZSB3rVoQnl/776YXU5VIZusvrVz8jo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    libxfce4ui
    gtk3
    polkit
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A simple PolicyKit authentication agent for XFCE";
    homepage = "https://github.com/ncopa/xfce-polkit";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.xfce.members ++ (with maintainers; [ baronleonardo ]);
  };
}
