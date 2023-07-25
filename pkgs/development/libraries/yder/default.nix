{ stdenv
, lib
, fetchFromGitHub
, cmake
, orcania
, systemd
, check
, subunit
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  pname = "yder";
  version = "1.4.19";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KP79i1yYJ6jrsdtS85fHOmJV+oAL/MNgc9On4RfOTwo=";
  };

  patches = [
    # We set CMAKE_INSTALL_LIBDIR to the absolute path in $out, so
    # prefix and exec_prefix cannot be $out, too
    ./fix-pkgconfig.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ orcania ]
    ++ lib.optional withSystemd systemd;

  nativeCheckInputs = [ check subunit ];

  cmakeFlags = [
    "-DBUILD_YDER_TESTING=on"
  ] ++ lib.optional (!withSystemd) "-DWITH_JOURNALD=off";

  doCheck = true;

  meta = with lib; {
    description = "Logging library for C applications";
    homepage = "https://github.com/babelouest/yder";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
