args: with args;

stdenv.mkDerivation {
  name = "qca-2.0.0dev";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qca;
	rev = 732646;
	md5 = "1df54bf3bf327b14ea1948f9080717c3";
  };

  buildInputs = [ cmake qt openssl gettext cyrus_sasl libgcrypt gnupg ];

  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../CMakeLists.txt";
}
