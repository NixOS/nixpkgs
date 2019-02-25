{ lib, fetchurl, pythonPackages, pkgconfig
, qmake, qtbase, qtsvg, qtwebengine
}:

let

  inherit (pythonPackages) buildPythonPackage python isPy3k pyqt5 enum34;

  sip = pythonPackages.sip.override { sip-module = "PyQt5.sip"; };

in buildPythonPackage rec {
  pname = "pyqtwebengine";
  version = "5.12";
  format = "other";

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/PyQtWebEngine/PyQtWebEngine_gpl-${version}.tar.gz";
    sha256 = "0j9zzgwrvh61mrzjfcdlhr08vg931ycb53ri51vynsj0grp07smn";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig qmake ];

  buildInputs = [ sip qtbase qtsvg qtwebengine ];

  propagatedBuildInputs = [ pyqt5 ]
    ++ lib.optional (!isPy3k) enum34;

  configurePhase = ''
    runHook preConfigure

    mkdir -p "$out/share/sip/PyQt5"

    # FIXME: Without --no-dist-info, I get
    #     unable to create /nix/store/yv4pzx3lxk3lscq0pw3hqzs7k4x76xsm-python3-3.7.2/lib/python3.7/site-packages/PyQtWebEngine-5.12.dist-info
    ${python.executable} configure.py -w \
      --destdir="$out/${python.sitePackages}" \
      --no-dist-info \
      --apidir="$out/api/${python.libPrefix}" \
      --sipdir="$out/share/sip/PyQt5" \
      --pyqt-sipdir="${pyqt5}/share/sip/PyQt5"

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = http://www.riverbankcomputing.co.uk;
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
  };
}
