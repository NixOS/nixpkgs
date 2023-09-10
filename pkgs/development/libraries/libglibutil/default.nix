{ stdenv, lib, fetchFromGitHub, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "libglibutil";
  version = "1.0.71";

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = pname;
    rev = version;
    sha256 = "sha256-I58XN1Ku5VVmxuTZ6yPm8jWGKscwLOhetWC+6B6EZRE=";
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
