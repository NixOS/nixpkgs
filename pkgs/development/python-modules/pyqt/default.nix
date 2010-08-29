{stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.7.4";
  
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.7.4.tar.gz;
    sha256 = "0a7iqzp75hd29rvwhyqfmaj5ymd49wq8scysjkivhc5qkx5rh00r";
  };
  
  preConfigure = ''
    ensureDir $out
    lndir ${pythonDBus} $out
    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages
    configureFlagsArray=( \
      --confirm-license --bindir $out/bin \
      --destdir $out/lib/${python.libPrefix}/site-packages \
      --plugin-destdir $out/lib/qt4/plugins --sipdir $out/share/sip \
      --dbus=$out/include/dbus-1.0 --verbose)
    '';

  configureScript="./configure.py";

  configurePhase = ''
    runHook preConfigure
    python configure.py $configureFlags "''${configureFlagsArray[@]}"
    runHook postConfigure'';
  
  propagatedBuildInputs = [ python sip qt4 ]
    ++ pythonDBus.propagatedBuildNativeInputs;
  buildInputs = [ pkgconfig makeWrapper lndir ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done'';
  
  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
