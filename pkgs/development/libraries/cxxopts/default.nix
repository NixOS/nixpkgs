{ lib
, stdenv
, fetchFromGitHub
, cmake
, icu
, pkg-config
, enableUnicodeHelp ? true
}:

stdenv.mkDerivation rec {
  pname = "cxxopts";
<<<<<<< HEAD
  version = "3.1.1";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lJPMaXBfrCeUhhXha5f7zmOGtyEDzU3oPTMirPTFZzQ=";
  };

=======
    sha256 = "08x7j168l1xwj0r3rv89cgghmfhsx98lpq35r3vkh504m1pd55a6";
  };

  # CMake does not set CMAKE_LIBRARY_ARCHITECTURE variable in Nix, which breaks architecture-independent library path generation
  patches = [ ./fix-install-path.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = lib.optionals enableUnicodeHelp [ icu.dev ];
  cmakeFlags = [ "-DCXXOPTS_BUILD_EXAMPLES=OFF" ]
    ++ lib.optional enableUnicodeHelp "-DCXXOPTS_USE_UNICODE_HELP=TRUE";
  nativeBuildInputs = [ cmake ] ++ lib.optionals enableUnicodeHelp [ pkg-config ];

  doCheck = true;

  # Conflict on case-insensitive filesystems.
  dontUseCmakeBuildDir = true;

  # https://github.com/jarro2783/cxxopts/issues/332
  postPatch = ''
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    homepage = "https://github.com/jarro2783/cxxopts";
    description = "Lightweight C++ GNU-style option parser library";
    license = licenses.mit;
    maintainers = [ maintainers.spease ];
    platforms = platforms.all;
  };
}
