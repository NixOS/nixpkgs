{ mkDerivation, lib, fetchFromGitHub, cmake, olm, openssl, qtmultimedia, qtkeychain }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-3xnv1dcyeX3Kl5EH2Tlf6nXobLG1zXsFmYstnvmSAXA=";
  };

  buildInputs = [ olm openssl qtmultimedia qtkeychain ];

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

  meta = with lib; {
    description = "A Qt5/Qt6 library to write cross-platform clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens ];
  };
}
