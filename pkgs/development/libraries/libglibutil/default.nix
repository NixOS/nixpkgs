{ stdenv, lib, fetchFromGitHub, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "libglibutil";
<<<<<<< HEAD
  version = "1.0.71";
=======
  version = "1.0.69";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-I58XN1Ku5VVmxuTZ6yPm8jWGKscwLOhetWC+6B6EZRE=";
=======
    sha256 = "sha256-+4aAujSmdrcRMnTd6wHHbyQBfC1LRskZ+8MA2d3hDnI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  postPatch = ''
    # Fix pkg-config name for cross-compilation
    substituteInPlace Makefile --replace "pkg-config" "$PKG_CONFIG"
  '';

  makeFlags = [
    "LIBDIR=$(out)/lib"
    "INSTALL_INCLUDE_DIR=$(dev)/include/gutil"
    "INSTALL_PKGCONFIG_DIR=$(dev)/lib/pkgconfig"
  ];

  installTargets = [ "install" "install-dev" ];

  postInstall = ''
    sed -i -e "s@includedir=/usr@includedir=$dev@g" $dev/lib/pkgconfig/$pname.pc
    sed -i -e "s@Cflags: @Cflags: $($PKG_CONFIG --cflags glib-2.0) @g" $dev/lib/pkgconfig/$pname.pc
  '';

  meta = with lib; {
    description = "Library of glib utilities.";
    homepage = "https://git.sailfishos.org/mer-core/libglibutil";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcaju ];
  };
}
