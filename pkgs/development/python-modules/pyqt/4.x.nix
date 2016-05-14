{ stdenv, fetchurl, python, pythonPackages, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

let version = "4.11.3";
in
stdenv.mkDerivation {
  name = "${python.libPrefix}-PyQt-x11-gpl-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4/PyQt-${version}/PyQt-x11-gpl-${version}.tar.gz";
    sha256 = "11jnfjw79s0b0qdd9s6kd69w87vf16dhagbhbmwbmrp2vgf80dw5";
  };

  configurePhase = ''
    mkdir -p $out
    lndir ${pythonDBus} $out

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'"

    configureFlagsArray=( \
      --confirm-license --bindir $out/bin \
      --destdir $out/lib/${python.libPrefix}/site-packages \
      --plugin-destdir $out/lib/qt4/plugins --sipdir $out/share/sip \
      --dbus=$out/include/dbus-1.0 --verbose)

    ${python.executable} configure.py $configureFlags "''${configureFlagsArray[@]}"
  '';

  buildInputs = [ python pkgconfig makeWrapper qt4 lndir ];

  propagatedBuildInputs = [ pythonPackages.sip_4_16 ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  passthru.pythonPath = [];

  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
