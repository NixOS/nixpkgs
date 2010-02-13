{ stdenv, fetchurl, lib, cmake, perl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4, boost
, kdelibs, kdepimlibs, automoc4, phonon, soprano, akonadi, qimageblitz, attica, polkit_qt
}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation {
  name = "kdebindings-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdebindings-4.4.0.tar.bz2;
    sha256 = "1yn0wynnigbp288j9pqfd5cppc6mja9z9pcfz7g789pmyig42jvd";
  };
  #builder = ./builder.sh;
  
  # Disable smoke because I don't need it and gives us an error
  cmakeFlags = [ "-DENABLE_SMOKE=OFF" ];
  preConfigure = ''
    cmakeFlags="$cmakeFlags -DPYTHON_SITE_PACKAGES_DIR=$out/lib/${python.libPrefix}/site-packages"
    cmakeFlags="$cmakeFlags -DSIP_DEFAULT_SIP_DIR=$out/share/sip"
  '';
  
  # Okular seems also an optional depenedency which I left out
  buildInputs = [ cmake perl python sip pyqt4 zlib libpng freetype fontconfig qt4 boost
		  kdelibs kdepimlibs automoc4 phonon soprano akonadi qimageblitz attica polkit_qt ];
  meta = {
    description = "KDE bindings";
    longDescription = "Provides KDE bindings for several languages such as Java, Smoke and Python";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
