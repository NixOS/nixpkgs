{ stdenv, fetchurl, pythonPackages, pkgconfig, qtbase, qtsvg, qtwebkit
, lndir, makeWrapper, qmakeHook }:

let
  version = "5.5.1";
  inherit (pythonPackages) python dbus-python;
  sip = pythonPackages.sip_4_16;
in stdenv.mkDerivation {
  name = "${python.libPrefix}-PyQt-${version}";

  meta = with stdenv.lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt-gpl-${version}.tar.gz";
    sha256 = "11l3pm0wkwkxzw4n3022iid3yyia5ap4l0ny1m5ngkzzzfafyw0a";
  };

  buildInputs = [
    pkgconfig makeWrapper lndir
    qtbase qtsvg qtwebkit qmakeHook
  ];

  propagatedBuildInputs = [ sip python ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p $out
    lndir ${dbus-python} $out

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'" \
      --replace "ModuleMetadata(qmake_QT=['webkitwidgets'])" "ModuleMetadata(qmake_QT=['webkitwidgets', 'printsupport'])"

    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus=$out/include/dbus-1.0 \
      --qmake=$QMAKE \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/lib/${python.libPrefix}/site-packages \
      --sipdir=$out/share/sip \
      --designer-plugindir=$out/plugins/designer

    runHook postConfigure
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  passthru.pythonPath = [];
}
