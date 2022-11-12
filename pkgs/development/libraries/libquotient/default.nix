{ mkDerivation, lib, fetchFromGitHub, cmake, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-FPtxeZOfChIPi4e/h/eZkByH1QL3Fn0OJxe0dnMcTRw=";
  };

  buildInputs = [ qtmultimedia ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # we need libqtolm for this
    "-DQuotient_ENABLE_E2EE=OFF"
  ];

  # https://github.com/quotient-im/libQuotient/issues/551
  postPatch = ''
    substituteInPlace Quotient.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "A Qt5 library to write cross-platform clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens ];
  };
}
