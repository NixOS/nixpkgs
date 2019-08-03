{ stdenv, lib, fetchFromGitHub, cmake, orcania, systemd, check, subunit
, withSystemd ? stdenv.isLinux
}:
assert withSystemd -> systemd != null;
stdenv.mkDerivation rec {
  pname = "yder";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j46v93vn130gjcr704rkdiibbk3ampzsqb6xdcrn4x115gwyf5i";
  };

  patches = [
    # We set CMAKE_INSTALL_LIBDIR to the absolute path in $out, so
    # prefix and exec_prefix cannot be $out, too
    ./fix-pkgconfig.patch

    # - ORCANIA_LIBRARIES must be set before target_link_libraries is called
    # - librt is not available, nor needed on Darwin
    # - The test binary is not linked against all necessary libraries
    # - Test for journald logging is not systemd specific and fails on darwin
    # - If the working directory is different from the build directory, the
    #   dynamic linker can't find libyder
    # - Return correct error code from y_init_logs when journald is disabled
    ./fix-darwin.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ orcania ] ++ lib.optional withSystemd systemd;

  checkInputs = [ check subunit ];

  cmakeFlags = [
    "-DBUILD_YDER_TESTING=on"
  ] ++ lib.optional (!withSystemd) "-DWITH_JOURNALD=off";

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
  '';

  meta = with lib; {
    description = "Logging library for C applications";
    homepage = "https://github.com/babelouest/yder";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
