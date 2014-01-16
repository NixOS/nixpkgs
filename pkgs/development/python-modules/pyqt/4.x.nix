{ stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

let version = "4.10.2"; # kde410.pykde4 doesn't build with 4.10.3
in
stdenv.mkDerivation {
  name = "PyQt-x11-gpl-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4/PyQt-${version}/PyQt-x11-gpl-${version}.tar.gz";
    sha256 = "1zp69caqq195ymp911d0cka8619q78hzmfxvj7c51w2y53zg4z3l";
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

  propagatedBuildInputs = [ sip ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
