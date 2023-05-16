{ stdenv, lib, fetchFromGitHub, pkg-config, glib, libglibutil }:

stdenv.mkDerivation rec {
  pname = "libgbinder";
<<<<<<< HEAD
  version = "1.1.34";
=======
  version = "1.1.33";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mer-hybris";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-e4J7K1AZyw3AvBNMj69VGKo7gtJ6Nr2ELjqgoqPlObU=";
=======
    sha256 = "sha256-tVvW7cbgj2t251SzUchfVEnHgLVgdkTLyGpQfn6VYow=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
