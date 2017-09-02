{ stdenv, fetchurl, pythonPackages, qt4, pkgconfig, lndir, dbus_libs, makeWrapper }:

let
  version = "4.12";
  inherit (pythonPackages) buildPythonPackage python dbus-python sip;
in buildPythonPackage {
  name = "PyQt-x11-gpl-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4_gpl_x11-${version}.tar.gz";
    sha256 = "1nw8r88a5g2d550yvklawlvns8gd5slw53yy688kxnsa65aln79w";
  };

  configurePhase = ''
    mkdir -p $out
    lndir ${dbus-python} $out
    rm -rf "$out/nix-support"

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      export QMAKESPEC="unsupported/macx-clang-libc++" # macOS target after bootstrapping phase \
    ''}

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'" \
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      --replace "qt_macx_spec = 'macx-g++'" "qt_macx_spec = 'unsupported/macx-clang-libc++'" # for bootstrapping phase \
    ''}

    configureFlagsArray=( \
      --confirm-license --bindir $out/bin \
      --destdir $out/${python.sitePackages} \
      --plugin-destdir $out/lib/qt4/plugins --sipdir $out/share/sip/PyQt4 \
      --dbus=${dbus-python}/include/dbus-1.0 --verbose)

    ${python.executable} configure.py $configureFlags "''${configureFlagsArray[@]}"
  '';

  buildInputs = [ pkgconfig makeWrapper qt4 lndir dbus_libs ];

  propagatedBuildInputs = [ sip ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  passthru = {
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
