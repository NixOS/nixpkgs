{ lib, fetchurl, fetchpatch, pythonPackages, pkgconfig
, qmake, lndir, qtbase, qtsvg, qtwebengine, dbus
, withConnectivity ? false, qtconnectivity
, withWebKit ? false, qtwebkit
, withWebSockets ? false, qtwebsockets
}:

let

  inherit (pythonPackages) buildPythonPackage python isPy3k dbus-python enum34;

  sip = pythonPackages.sip.override { sip-module = "PyQt5.sip"; };

in buildPythonPackage rec {
  pname = "PyQt";
  version = "5.11.3";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt5_gpl-${version}.tar.gz";
    sha256 = "0wqh4srqkcc03rvkwrcshaa028psrq58xkys6npnyhqxc0apvdf9";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig qmake lndir sip ];

  buildInputs = [ dbus sip ];

  propagatedBuildInputs = [ qtbase qtsvg qtwebengine dbus-python ]
    ++ lib.optional (!isPy3k) enum34
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets;

  patches = [
    # Fix some wrong assumptions by ./configure.py
    # TODO: figure out how to send this upstream
    ./pyqt5-fix-dbus-mainloop-support.patch
  ];

  configurePhase = ''
    runHook preConfigure

    export PYTHONPATH=$PYTHONPATH:$out/${python.sitePackages}

    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus-moduledir=$out/${python.sitePackages}/dbus/mainloop \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/${python.sitePackages} \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --sipdir=$out/share/sip/PyQt5 \
      --designer-plugindir=$out/plugins/designer

    runHook postConfigure
  '';

  postInstall = ''
    ln -s ${sip}/${python.sitePackages}/PyQt5/sip.* $out/${python.sitePackages}/PyQt5/
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
