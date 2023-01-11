{ mkDerivation, lib, fetchFromGitHub, cmake, qtmultimedia, qtkeychain }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-9NAWphpAI7/qWDMjsx26s+hOaQh0hbzjePfESC7PtXc=";
  };

  buildInputs = [ qtmultimedia qtkeychain ];

  nativeBuildInputs = [ cmake ];

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
