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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "v${version}";
    sha256 = "08x7j168l1xwj0r3rv89cgghmfhsx98lpq35r3vkh504m1pd55a6";
  };

  # CMake does not set CMAKE_LIBRARY_ARCHITECTURE variable in Nix, which breaks architecture-independent library path generation
  patches = [ ./fix-install-path.patch ];

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
