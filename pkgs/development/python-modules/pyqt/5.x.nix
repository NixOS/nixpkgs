{ stdenv, fetchurl, python, pkgconfig, qt5, sip, pythonDBus, lndir, makeWrapper }:

let
  version = "5.4.2";
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
    sha256 = "1402n5kwzd973b65avxk1j9js96wzfm0yw4rshjfy8l7an00bnac";
  };

  buildInputs = [
    python pkgconfig makeWrapper lndir
    qt5.base qt5.svg qt5.webkit
  ];

  propagatedBuildInputs = [ sip ];

  configurePhase = ''
    mkdir -p $out
    lndir ${pythonDBus} $out

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'" \
      --replace "ModuleMetadata(qmake_QT=['webkitwidgets'])" "ModuleMetadata(qmake_QT=['webkitwidgets', 'printsupport'])"

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
