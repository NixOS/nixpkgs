{ lib, fetchurl, pythonPackages, pkgconfig, qtbase, qtsvg, qtwebkit, dbus_libs
, lndir, makeWrapper, qmakeHook }:

let
  version = "5.6";
  inherit (pythonPackages) mkPythonDerivation python dbus-python sip;
in mkPythonDerivation {
  name = "PyQt-${version}";

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt5_gpl-${version}.tar.gz";
    sha256 = "1qgh42zsr9jppl9k7fcdbhxcd1wrb7wyaj9lng9nxfa19in1lj1f";
  };

  buildInputs = [
    pkgconfig makeWrapper lndir
    qtbase qtsvg qtwebkit dbus_libs qmakeHook
  ];

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
      --qmake=$QMAKE \
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
