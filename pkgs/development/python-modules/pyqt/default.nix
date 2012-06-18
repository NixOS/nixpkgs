{ stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

stdenv.mkDerivation rec {
  name = "PyQt-x11-gpl-4.9.1";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/${name}.tar.gz";
    sha256 = "1ccvc80z8a0k0drvba9ngivsnv2k2nn5317yf86w1zwh45zmb0zj";
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

    python configure.py $configureFlags "''${configureFlagsArray[@]}"
  '';

  buildInputs = [ python pkgconfig makeWrapper qt4 lndir ];

  propagatedBuildInputs = [ sip ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  ''; # */

  enableParallelBuilding = true;
  
  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
