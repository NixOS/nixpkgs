{ stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

stdenv.mkDerivation rec {
  name = "PyQt-x11-gpl-4.8.4";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/${name}.tar.gz";
    sha256 = "161y1c39zr9dyl2nkllxw5711sl1dxmb6lbp4a9nvbag1g63xypw";
  };
  
  configurePhase = ''
    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'"
  
    configureFlagsArray=( \
      --confirm-license --bindir $out/bin \
      --destdir $out/lib/${python.libPrefix}/site-packages \
      --plugin-destdir $out/lib/qt4/plugins --sipdir $out/share/sip \
      --dbus=${pythonDBus}/include/dbus-1.0 --verbose)

    python configure.py $configureFlags "''${configureFlagsArray[@]}"
  '';

  buildInputs = [ python pkgconfig makeWrapper qt4 ];

  propagatedBuildInputs = [ sip pythonDBus ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : $out/lib/${python.libPrefix}/site-packages:$PYTHONPATH
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
