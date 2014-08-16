{ stdenv, fetchurl, python, pkgconfig, qt5, sip, pythonDBus, lndir, makeWrapper }:

let
  version = "5.3";
in stdenv.mkDerivation {
  name = "PyQt-${version}";

  meta = with stdenv.lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander iyzsong ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt-gpl-${version}.tar.gz";
    sha256 = "0xc1cc68fi989rfybibimhhi3mqn3b93n0p3jdqznzabgilcb1m2";
  };

  buildInputs = [ python pkgconfig makeWrapper lndir qt5 ];

  propagatedBuildInputs = [ sip ];

  configurePhase = ''
    mkdir -p $out
    lndir ${pythonDBus} $out

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'"

    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus=$out/include/dbus-1.0 \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/lib/${python.libPrefix}/site-packages \
      --sipdir=$out/share/sip \
      --designer-plugindir=$out/plugins/designer
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;
}
