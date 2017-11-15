{ lib, fetchurl, pythonPackages, pkgconfig, makeWrapper, qmake
, lndir, qtbase, qtsvg, qtwebkit, qtwebengine, dbus_libs
, withWebSockets ? false, qtwebsockets
}:

let
  version = "5.9";
  inherit (pythonPackages) buildPythonPackage python dbus-python sip;
in buildPythonPackage {
  name = "PyQt-${version}";
  format = "other";

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt5_gpl-${version}.tar.gz";
    sha256 = "15hh4z5vd45dcswjla58q6rrfr6ic7jfz2n7c8lwfb10rycpj3mb";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper qmake ];

  buildInputs = [
    lndir qtbase qtsvg qtwebkit qtwebengine dbus_libs
  ] ++ lib.optional withWebSockets qtwebsockets;

  propagatedBuildInputs = [ sip ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p $out
    lndir ${dbus-python} $out
    rm -rf "$out/nix-support"

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'" \
      --replace "ModuleMetadata(qmake_QT=['webkitwidgets'])" "ModuleMetadata(qmake_QT=['webkitwidgets', 'printsupport'])"

    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus=${dbus_libs.dev}/include/dbus-1.0 \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/${python.sitePackages} \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --sipdir=$out/share/sip/PyQt5 \
      --designer-plugindir=$out/plugins/designer

    runHook postConfigure
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;
}
