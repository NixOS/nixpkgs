{stdenv, fetchurl, qt4}:

stdenv.mkDerivation {
  name = "qtscriptgenerator-0.1.0";
  src = fetchurl {
    url = http://qtscriptgenerator.googlecode.com/files/qtscriptgenerator-src-0.1.0.tar.gz;
    sha256 = "0h8zjh38n2wfz7jld0jz6a09y66dbsd2jhm4f2024qfgcmxcabj6";
  };
  buildInputs = [ qt4 ];

  patches = [ ./qtscriptgenerator.gcc-4.4.patch ./qt-4.8.patch ];
  
  # Why isn't the author providing proper Makefile or a CMakeLists.txt ?
  buildPhase = ''
    # remove phonon stuff which causes errors (thanks to Gentoo bug reports)
    sed -i "/typesystem_phonon.xml/d" generator/generator.qrc
    sed -i "/qtscript_phonon/d" qtbindings/qtbindings.pro	    
  
    cd generator
    qmake
    make
    # Set QTDIR, see http://code.google.com/p/qtscriptgenerator/issues/detail?id=38
    QTDIR=${qt4} ./generator
    cd ../qtbindings
    qmake
    make
  '';
  
  installPhase = ''
    cd ..
    mkdir -p $out/lib/qt4/plugins/script
    cp -av plugins/script/* $out/lib/qt4/plugins/script
  '';

  meta = {
    description = "QtScript bindings generator";
    homepage = http://code.google.com/p/qtscriptgenerator/;
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
