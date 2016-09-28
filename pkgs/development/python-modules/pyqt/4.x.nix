{ stdenv, fetchurl, pythonPackages, qt4, pkgconfig, lndir, dbus_libs, makeWrapper }:

let
  version = "4.11.3";
  inherit (pythonPackages) python dbus-python sip;
in stdenv.mkDerivation {
  name = "${python.libPrefix}-PyQt-x11-gpl-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4/PyQt-${version}/PyQt-x11-gpl-${version}.tar.gz";
    sha256 = "11jnfjw79s0b0qdd9s6kd69w87vf16dhagbhbmwbmrp2vgf80dw5";
  };

  configurePhase = ''
    mkdir -p $out
    lndir ${dbus-python} $out

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'"

    configureFlagsArray=( \
      --confirm-license --bindir $out/bin \
      --destdir $out/${python.sitePackages} \
      --plugin-destdir $out/lib/qt4/plugins --sipdir $out/share/sip/PyQt4 \
      --dbus=${dbus_libs.dev}/include/dbus-1.0 --verbose)

    ${python.executable} configure.py $configureFlags "''${configureFlagsArray[@]}"
  '';

  buildInputs = [ pkgconfig makeWrapper qt4 lndir dbus_libs ];

  propagatedBuildInputs = [ sip python ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  passthru = {
    pythonPath = [];
    qt = qt4;
  };

  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
