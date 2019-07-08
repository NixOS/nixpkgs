{ stdenv, fetchurl, buildPythonPackage, python, dbus-python, sip, qt4, pkgconfig, lndir, dbus, makeWrapper }:

buildPythonPackage rec {
  pname = "PyQt-x11-gpl";
  version = "4.12";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4_gpl_x11-${version}.tar.gz";
    sha256 = "1nw8r88a5g2d550yvklawlvns8gd5slw53yy688kxnsa65aln79w";
  };

  postPatch = ''
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

    chmod +x configure.py
    sed -i '1i#!${python.interpreter}' configure.py
  '';

  configureScript = "./configure.py";
  dontAddPrefix = true;
  configureFlags = [
    "--confirm-license"
    "--bindir=${placeholder "out"}/bin"
    "--destdir=${placeholder "out"}/${python.sitePackages}"
    "--plugin-destdir=${placeholder "out"}/lib/qt4/plugins"
    "--sipdir=${placeholder "out"}/share/sip/PyQt4"
    "--dbus=${stdenv.lib.getDev dbus-python}/include/dbus-1.0"
    "--verbose"
  ];

  nativeBuildInputs = [ pkgconfig lndir makeWrapper qt4 ];
  buildInputs = [ qt4 dbus ];

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
