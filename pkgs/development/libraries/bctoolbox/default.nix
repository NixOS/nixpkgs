{ bcunit
, cmake
, bc-decaf
, fetchFromGitLab
, mbedtls_2
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bctoolbox";
<<<<<<< HEAD
  version = "5.2.98";
=======
  version = "5.2.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    # Made by BC
    bcunit

    # Vendored by BC
    bc-decaf

    mbedtls_2
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-j1vVd9UcwmP3tGGN6NApiMyOql8vYljTqj3CKor1Ckk=";
=======
    hash = "sha256-M2apFibqSKp8ojXl82W+vQb7CUxdbWsmw8PLL/ByYuM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" "-DENABLE_STRICT=NO" ];

  strictDeps = true;

  meta = with lib; {
    description = "Utilities library for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.linux;
  };
}
