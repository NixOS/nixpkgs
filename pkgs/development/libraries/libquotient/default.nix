{ stdenv, lib, fetchFromGitHub, cmake, olm, openssl, qtbase, qtmultimedia, qtkeychain }:

stdenv.mkDerivation rec {
  pname = "libquotient";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-ecTHiWbsNDIUz+Sadh2pVbDRZFzdMkZXBYSjy1JqZrk=";
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
    maintainers = with maintainers; [ colemickens matthiasbeyer ];
  };
}
