{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, gtk3
, libintl
}:

stdenv.mkDerivation rec {
  pname = "lxtask";
  version = "0.1.10";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${pname}-${version}.tar.xz";
    sha256 = "0b2fxg8jjjpk219gh7qa18g45365598nd2bq7rrq0bdvqjdxy5i2";
  };

  nativeBuildInputs = [ pkg-config intltool ];

  buildInputs = [ gtk3 libintl ];

  configureFlags = [ "--enable-gtk3" ];

  meta = with lib; {
    homepage = "https://wiki.lxde.org/en/LXTask";
    description = "Lightweight and desktop independent task manager";
    mainProgram = "lxtask";
    longDescription = ''
      LXTask is a lightweight task manager derived from xfce4 task manager
      with all xfce4 dependencies removed, some bugs fixed, and some
      improvement of UI. Although being part of LXDE, the Lightweight X11
      Desktop Environment, it's totally desktop independent and only
      requires pure GTK.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
