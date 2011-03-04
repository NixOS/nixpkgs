{stdenv, fetchurl, python, sip, qt4, pythonDBus, pkgconfig, lndir, makeWrapper }:

stdenv.mkDerivation rec {
  name = "PyQt-x11-gpl-4.8.1";
  
  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.gz";
    sha256 = "0w7k1jz7wcfwqq77hiwgds5s6py7kkg1rszd6c94bk9dr06vishz";
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
