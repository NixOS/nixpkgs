{ stdenv, lib, fetchFromGitHub, cmake, olm, openssl, qtbase, qtmultimedia, qtkeychain }:

stdenv.mkDerivation rec {
  pname = "libquotient";
<<<<<<< HEAD
  version = "0.8.1.1";
=======
  version = "0.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-WNLwO2w8FYy12BeqPuiS0wg3fUMwTxfrIF1QwcjE9yQ=";
=======
    hash = "sha256-Lq404O2VjZ8vlXOW+rhsvWDvZsNd3APNbv6AadQCjhk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ colemickens matthiasbeyer ];
=======
    maintainers = with maintainers; [ colemickens ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
