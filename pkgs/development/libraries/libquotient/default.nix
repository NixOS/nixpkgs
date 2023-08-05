{ stdenv, lib, fetchFromGitHub, cmake, olm, openssl, qtbase, qtmultimedia, qtkeychain }:

stdenv.mkDerivation rec {
  pname = "libquotient";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-Lq404O2VjZ8vlXOW+rhsvWDvZsNd3APNbv6AadQCjhk=";
  };

  buildInputs = [ olm openssl qtbase qtmultimedia qtkeychain ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DQuotient_ENABLE_E2EE=ON"
  ];

  # https://github.com/quotient-im/libQuotient/issues/551
  postPatch = ''
    substituteInPlace Quotient.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "A Qt5/Qt6 library to write cross-platform clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens ];
  };
}
