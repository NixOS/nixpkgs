{ lib
, stdenv
, fetchFromGitea
, cmake
, pkg-config
, lz4
, pugixml
, zlib
<<<<<<< HEAD
, zstd
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxisf";
<<<<<<< HEAD
  version = "0.2.9";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "gitea.nouspiro.space";
    owner = "nou";
    repo = "libXISF";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Jh3NWtQSV0uePDMCDNzdI4qpRGbHTel3neRZAA3anQk=";
  };

  patches = [
    ./0001-Fix-pkg-config-paths.patch
  ];

=======
    hash = "sha256-u5EYnRO2rUV8ofLL9qfACeVvVbWXEXpkqh2Q4OOxpaQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DUSE_BUNDLED_LIBS=OFF"
  ] ++ lib.optional stdenv.hostPlatform.isStatic "-DBUILD_SHARED_LIBS=OFF";

  buildInputs = [
    lz4
    pugixml
    zlib
<<<<<<< HEAD
    zstd
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library to load and write XISF format from PixInsight";
    homepage = "https://gitea.nouspiro.space/nou/libXISF";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.linux;
  };
})
