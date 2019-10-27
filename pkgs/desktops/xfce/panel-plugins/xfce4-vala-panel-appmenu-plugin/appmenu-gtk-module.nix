{ stdenv, fetchFromGitHub, cmake, vala, glib, gtk2, gtk3 }:
stdenv.mkDerivation rec {
  pname = "vala-panel-appmenu-xfce";
  version = "0.6.94";

  src = "${fetchFromGitHub {
    owner = "rilian-la-te";
    repo = "vala-panel-appmenu";
    rev = version;
    fetchSubmodules = true;

    sha256 = "0xxn3zs60a9nfix8wrdp056wviq281cm1031hznzf1l38lp3wr5p";
  }}/subprojects/appmenu-gtk-module";

  nativeBuildInputs = [ cmake vala ];
  buildInputs = [ glib gtk2 gtk3 ];

  configurePhase = ''
    cmake . -DGTK3_INCLUDE_GDK=
  '';
  installPhase = ''
    make DESTDIR=output install
    cp -r output/var/empty/* "$out"
  '';

  meta = with stdenv.lib; {
    description = "Port of the Unity GTK Module";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
