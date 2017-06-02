{ lib, fetchurl, pythonPackages, pkgconfig, qtbase, qtsvg, qtwebkit, qtwebengine, dbus_libs
, lndir, makeWrapper, qmake }:

let
  version = "5.8.1";
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
    sha256 = "0biak7l574i2gc8lj1s45skajbxsmmx66nlvs6xaakzkc6r293qy";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper qmake ];

  buildInputs = [
    lndir qtbase qtsvg qtwebkit qtwebengine dbus_libs
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
