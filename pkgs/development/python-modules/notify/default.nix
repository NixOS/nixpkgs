{ stdenv
, fetchurl
, python
, pygobject2
, pygtk
, pkgs
}:

stdenv.mkDerivation rec {
  name = "python-notify-${version}";
  version = "0.1.1";

  src = fetchurl {
    url = http://www.galago-project.org/files/releases/source/notify-python/notify-python-0.1.1.tar.bz2;
    sha256 = "1kh4spwgqxm534qlzzf2ijchckvs0pwjxl1irhicjmlg7mybnfvx";
  };

  patches = stdenv.lib.singleton (fetchurl {
    name = "libnotify07.patch";
    url = "https://src.fedoraproject.org/cgit/notify-python.git/plain/"
        + "libnotify07.patch?id2=289573d50ae4838a1658d573d2c9f4c75e86db0c";
    sha256 = "1lqdli13mfb59xxbq4rbq1f0znh6xr17ljjhwmzqb79jl3dig12z";
  });

  postPatch = ''
    sed -i -e '/^PYGTK_CODEGEN/s|=.*|="${pygtk}/bin/pygtk-codegen-2.0"|' \
      configure
  '';

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ python pygobject2 pygtk pkgs.libnotify pkgs.glib pkgs.gtk2 pkgs.dbus-glib ];

  postInstall = "cd $out/lib/python*/site-packages && ln -s gtk-*/pynotify .";

  meta = with stdenv.lib; {
    description = "Python bindings for libnotify";
    homepage = http://www.galago-project.org/;
    license = licenses.lgpl3;
  };

}
