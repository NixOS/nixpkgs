args: with args;

stdenv.mkDerivation {
  name = "qca-2.0.0dev";
  src = svnSrc "qca" "1jdqh7xg3vqyx7lgngcz9qj6zdnmlwqw7yv2py7gp2qma7a0annd";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl libgcrypt gnupg ];
  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../CMakeLists.txt";
}
