{ stdenv, lib, fetchFromGitHub, pkg-config, glib, libglibutil }:

stdenv.mkDerivation rec {
  pname = "libgbinder";
  version = "1.1.34";

  src = fetchFromGitHub {
    owner = "mer-hybris";
    repo = pname;
    rev = version;
    sha256 = "sha256-e4J7K1AZyw3AvBNMj69VGKo7gtJ6Nr2ELjqgoqPlObU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    libglibutil
  ];

  postPatch = ''
    # Fix pkg-config and ranlib names for cross-compilation
    substituteInPlace Makefile \
      --replace "pkg-config" "$PKG_CONFIG" \
      --replace "ranlib" "$RANLIB"
  '';

  makeFlags = [
    "LIBDIR=$(out)/lib"
    "INSTALL_INCLUDE_DIR=$(dev)/include/gbinder"
    "INSTALL_PKGCONFIG_DIR=$(dev)/lib/pkgconfig"
  ];

  installTargets = [ "install" "install-dev" ];

  postInstall = ''
    sed -i -e "s@includedir=/usr@includedir=$dev@g" $dev/lib/pkgconfig/$pname.pc
    sed -i -e "s@Cflags: @Cflags: $($PKG_CONFIG --cflags libglibutil) @g" $dev/lib/pkgconfig/$pname.pc
  '';

  meta = with lib; {
    description = "GLib-style interface to binder";
    homepage = "https://github.com/mer-hybris/libgbinder";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcaju ];
  };
}
