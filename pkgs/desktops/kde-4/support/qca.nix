args: with args;

stdenv.mkDerivation {
  name = "qca-2.0.0dev";
  src = svnSrc "qca" "0dycmk8fn57mz2pfxck6d0g833fqg9zrw17789vxb4ks0xz0p3zp";
  buildInputs = [ cmake qt openssl gettext cyrus_sasl libgcrypt gnupg ];
  patchPhase = "sed -e '/set(qca_PLUGINSDIR/s@\${QT_PLUGINS_DIR}@\${CMAKE_INSTALL_PREFIX}/plugins@' -i ../CMakeLists.txt";
}
