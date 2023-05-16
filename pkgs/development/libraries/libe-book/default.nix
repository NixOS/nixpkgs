{ lib
, stdenv
, fetchurl
, gperf
, pkg-config
, librevenge
, libxml2
, boost
, icu
, cppunit
, zlib
, liblangtag
}:

stdenv.mkDerivation rec {
  pname = "libe-book";
  version = "0.1.3";
<<<<<<< HEAD

  src = fetchurl {
    url = "mirror://sourceforge/libebook/libe-book-${version}/libe-book-${version}.tar.xz";
    hash = "sha256-fo2P808ngxrKO8b5zFMsL5DSBXx3iWO4hP89HjTf4fk=";
  };

  # restore compatibility with icu68+
  postPatch = ''
    substituteInPlace src/lib/EBOOKCharsetConverter.cpp --replace \
      "TRUE, TRUE, &status)" \
      "true, true, &status)"
  '';
  nativeBuildInputs = [ pkg-config ];

=======
  src = fetchurl {
    url = "https://kent.dl.sourceforge.net/project/libebook/libe-book-${version}/libe-book-${version}.tar.xz";
    sha256 = "sha256-fo2P808ngxrKO8b5zFMsL5DSBXx3iWO4hP89HjTf4fk=";
  };
  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    gperf
    librevenge
    libxml2
    boost
    icu
    cppunit
    zlib
    liblangtag
  ];
<<<<<<< HEAD

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

=======
  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Library for import of reflowable e-book formats";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
