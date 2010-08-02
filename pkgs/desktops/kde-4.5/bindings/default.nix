{ stdenv, fetchurl, lib, cmake, perl, python, sip, pyqt4, zlib, libpng, freetype, fontconfig, qt4, boost
, kdelibs, kdepimlibs, automoc4, soprano, akonadi, attica, polkit_qt_1, ruby
}:

# This function will only build the pykde4 module. I don't need the other bindings and
# some bindings are even broken.

stdenv.mkDerivation rec {
  name = "kdebindings-4.4.95";
  
  src = fetchurl {
    url = "mirror://kde/unstable/4.4.95/src/${name}.tar.bz2";
    sha256 = "115xl1jcpnyr71573if0nvb3hy8z5hxqy5qlvc71pdprzrp78xbc";
  };

  patches = [ ./python-site-packages-install-dir.diff ];

  preConfigure = ''
    CUSTOM_RUBY_SITE_ARCH_DIR=$(ruby -r rbconfig -e "print Config::CONFIG['sitearchdir']" | sed -e "s@${ruby}@$out@")
    CUSTOM_RUBY_SITE_LIB_DIR=$(ruby -r rbconfig -e "print Config::CONFIG['sitelibdir']" | sed -e "s@${ruby}@$out@")
	CUSTOM_PERL_SITE_ARCH_DIR=$(perl -MConfig -e 'print $Config{sitearch}' | sed -e "s@${perl}@$out@")
    cmakeFlagsArray=(
	  -DSIP_DEFAULT_SIP_DIR=$out/share/sip
      -DCUSTOM_RUBY_SITE_ARCH_DIR=$CUSTOM_RUBY_SITE_ARCH_DIR
	  -DCUSTOM_RUBY_SITE_LIB_DIR=$CUSTOM_RUBY_SITE_LIB_DIR
	  -DCUSTOM_PERL_SITE_ARCH_DIR=$CUSTOM_PERL_SITE_ARCH_DIR
	)
  '';
  
  # Okular seems also an optional depenedency which I left out
  buildInputs = [ cmake perl python sip pyqt4 zlib libpng freetype fontconfig qt4 boost
		  kdelibs kdepimlibs automoc4 soprano akonadi attica polkit_qt_1 ruby ];

  meta = {
    description = "KDE bindings";
    longDescription = "Provides KDE bindings for several languages such as Java, Smoke and Python";
    license = "LGPL";
    homepage = http://www.kde.org;
	inherit (kdelibs.meta) maintainers;
  };
}

