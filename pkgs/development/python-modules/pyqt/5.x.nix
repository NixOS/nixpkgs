{ lib, fetchurl, pythonPackages, pkgconfig, makeWrapper, qmake
, lndir, qtbase, qtsvg, qtwebkit, qtwebengine, dbus_libs
, withWebSockets ? false, qtwebsockets
, withConnectivity ? false, qtconnectivity
}:

let
  pname = "PyQt";
  version = "5.10";

  inherit (pythonPackages) buildPythonPackage python dbus-python sip;

in buildPythonPackage {
  pname = pname;
  version = version;
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
    sha256 = "0l2zy6b7bfjxmg4bb8yikg6i8iy2xdwmvk7knfmrzfpqbmkycbrl";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig qmake lndir ];

  buildInputs = [ dbus_libs ];

  propagatedBuildInputs = [
    sip qtbase qtsvg qtwebkit qtwebengine
  ] ++ lib.optional withWebSockets qtwebsockets ++ lib.optional withConnectivity qtconnectivity;

  configurePhase = ''
    runHook preConfigure

    mkdir -p $out
    lndir ${dbus-python} $out
    rm -rf "$out/nix-support"

    export PYTHONPATH=$PYTHONPATH:$out/${python.sitePackages}

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/${python.sitePackages}/dbus/mainloop'" \
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
