{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation {
  pname = "tdlib";
  version = "1.8.27";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    # The tdlib authors do not set tags for minor versions, but
    # external programs depending on tdlib constrain the minor
    # version, hence we set a specific commit with a known version.
    rev = "efc6bd553b61dea0ae8c0436695e8d2539bf03f9";
    hash = "sha256-AHfuT+bLkc8Lm1B96E/kwUx1ZKStQbv/skH8woRITRk=";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  # https://github.com/tdlib/td/issues/1974
  postPatch = ''
    substituteInPlace CMake/GeneratePkgConfig.cmake \
      --replace 'function(generate_pkgconfig' \
                'include(GNUInstallDirs)
                 function(generate_pkgconfig' \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    sed -i "/vptr/d" test/CMakeLists.txt
  '';

  meta = with lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.unix;
    maintainers = [ maintainers.vyorkin ];
  };
}
