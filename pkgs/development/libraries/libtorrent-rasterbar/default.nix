{ lib, stdenv, fetchFromGitHub, cmake
, zlib, boost, openssl, python, ncurses, SystemConfiguration
}:

let
  version = "2.0.8";

  # Make sure we override python, so the correct version is chosen
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "sha256-mMY3NiSL/lYuYmV/KWgfKbs8XukSV4PvQ87tpgBid6M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boostPython openssl zlib python ncurses ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  # https://github.com/arvidn/libtorrent/issues/6865
  postPatch = ''
    substituteInPlace cmake/Modules/GeneratePkgConfig.cmake \
      --replace @CMAKE_INSTALL_PREFIX@/'$<'1: '$<'1:
    substituteInPlace cmake/Modules/GeneratePkgConfig/target-compile-settings.cmake.in \
      --replace 'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")' \
                'set(_INSTALL_LIBDIR "@CMAKE_INSTALL_LIBDIR@")
                 set(_INSTALL_FULL_LIBDIR "@CMAKE_INSTALL_FULL_LIBDIR@")'
    substituteInPlace cmake/Modules/GeneratePkgConfig/pkg-config.cmake.in \
      --replace '$'{prefix}/@_INSTALL_LIBDIR@ @_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

  cmakeFlags = [
    "-Dpython-bindings=on"
  ];

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
