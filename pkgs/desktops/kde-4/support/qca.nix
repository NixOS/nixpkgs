args: with args;

stdenv.mkDerivation {
  name = "qca-2.0.0dev";
  src = svnSrc "qca" "1dm7q9v54ps0iix55hx4y51k379gqiwai5ym7avafis9j0py28aj";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl libgcrypt gnupg ];
  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../CMakeLists.txt";
}
