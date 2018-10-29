{ lib, fetchurl, fetchpatch, pythonPackages, pkgconfig
, qmake, lndir, qtbase, qtsvg, qtwebkit, qtwebengine, dbus
, withWebSockets ? false, qtwebsockets
, withConnectivity ? false, qtconnectivity
}:

let
  pname = "PyQt";
  version = "5.11.3";

  inherit (pythonPackages) buildPythonPackage python isPy3k dbus-python sip enum34;

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
    sha256 = "0wqh4srqkcc03rvkwrcshaa028psrq58xkys6npnyhqxc0apvdf9";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig qmake lndir ];

  buildInputs = [ dbus ];

  propagatedBuildInputs = [
    sip qtbase qtsvg qtwebkit qtwebengine
  ] ++ lib.optional (!isPy3k) enum34 ++ lib.optional withWebSockets qtwebsockets ++ lib.optional withConnectivity qtconnectivity;

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
      --dbus=${dbus.dev}/include/dbus-1.0 \
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
