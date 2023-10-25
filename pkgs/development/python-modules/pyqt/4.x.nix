{ lib, stdenv, fetchurl, buildPythonPackage, python, dbus-python, sip_4, qt4, pkg-config, lndir, dbus, makeWrapper }:

buildPythonPackage rec {
  pname = "PyQt-x11-gpl";
  version = "4.12.3";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt4_gpl_x11-${version}.tar.gz";
    sha256 = "0wnlasg62rm5d39nq1yw4namcx2ivxgzl93r5f2vb9s0yaz5l3x0";
  };

  postPatch = ''
    mkdir -p $out
    lndir ${dbus-python} $out
    rm -rf "$out/nix-support"

    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}/site-packages
    ${lib.optionalString stdenv.isDarwin ''
      export QMAKESPEC="unsupported/macx-clang-libc++" # macOS target after bootstrapping phase \
    ''}

    substituteInPlace configure.py \
      --replace 'install_dir=pydbusmoddir' "install_dir='$out/lib/${python.libPrefix}/site-packages/dbus/mainloop'" \
    ${lib.optionalString stdenv.isDarwin ''
      --replace "qt_macx_spec = 'macx-g++'" "qt_macx_spec = 'unsupported/macx-clang-libc++'" # for bootstrapping phase \
    ''}

    chmod +x configure.py
    sed -i '1i#!${python.pythonForBuild.interpreter}' configure.py
  '';

  configureScript = "./configure.py";
  dontAddPrefix = true;
  configureFlags = [
    "--confirm-license"
    "--bindir=${placeholder "out"}/bin"
    "--destdir=${placeholder "out"}/${python.sitePackages}"
    "--plugin-destdir=${placeholder "out"}/lib/qt4/plugins"
    "--sipdir=${placeholder "out"}/share/sip/PyQt4"
    "--dbus=${lib.getDev dbus-python}/include/dbus-1.0"
    "--verbose"
  ];

  nativeBuildInputs = [ pkg-config lndir makeWrapper qt4 ];
  buildInputs = [ qt4 dbus ];

  propagatedBuildInputs = [ sip_4 ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;

  passthru = {
    qt = qt4;
  };

  meta = with lib; {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = "http://www.riverbankcomputing.co.uk";
    maintainers = [ maintainers.sander ];
    platforms = platforms.mesaPlatforms;
  };
}
