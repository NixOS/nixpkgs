{ stdenv, lib, fetchFromGitHub, cmake, orcania, systemd, check, subunit
, withSystemd ? stdenv.isLinux
}:
assert withSystemd -> systemd != null;
stdenv.mkDerivation rec {
  pname = "yder";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "19ghiwpi972wjqvlgg576nk2nkf1ii5l1kvzb056496xfmlysrwa";
  };

  patches = [
    # We set CMAKE_INSTALL_LIBDIR to the absolute path in $out, so
    # prefix and exec_prefix cannot be $out, too
    ./fix-pkgconfig.patch
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
    export DYLD_FALLBACK_LIBRARY_PATH="$(pwd):$DYLD_FALLBACK_LIBRARY_PATH"
  '';

  meta = with lib; {
    description = "Logging library for C applications";
    homepage = "https://github.com/babelouest/yder";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
