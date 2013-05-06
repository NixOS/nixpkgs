{ stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

stdenv.mkDerivation rec {
  name = "PyQt-x11-gpl-4.10.1";
  
  src = fetchurl {
    urls = [
      "http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/${name}.tar.gz"
      "http://pkgs.fedoraproject.org/lookaside/pkgs/PyQt4/PyQt-x11-gpl-4.10.1.tar.gz/e5973c4ec0b0469f329bc00209d2ad9c/PyQt-x11-gpl-4.10.1.tar.gz"
    ];
    sha256 = "05psk23x6bc83hrkw7h88a14jxhvfbxms0c8yrdar8xqvkv8cdb2";
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
