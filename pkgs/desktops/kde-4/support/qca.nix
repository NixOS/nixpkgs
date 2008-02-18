args: with args;

stdenv.mkDerivation {
  name = "qca-2.0.0dev";
  src = svnSrc "qca" "204ffa1c50525be4c3b1a4ef9c91f745e412340afad538cbf7d1d587453a28d7";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl libgcrypt gnupg ];
  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../CMakeLists.txt";
}
