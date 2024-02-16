{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libyang
, pcre2
, validatePkgConfig
}:

stdenv.mkDerivation rec {
  pname = "sysrepo";
  version = "2.2.150";

  src = fetchFromGitHub {
    owner = "sysrepo";
    repo = "sysrepo";
    rev = "v${version}";
    hash = "sha256-4De10Lp4XCnphypzw1K+jY3LHbDd1FdP3cnu28BIFJg=";
  };

  postPatch = ''
    substituteInPlace sysrepo.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib" \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "\''${prefix}/include"
  '';


  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    libyang
    pcre2
  ];

  meta = with lib; {
    description = "YANG-based configuration and operational state data store for Unix/Linux applications";
    homepage = "https://github.com/sysrepo/sysrepo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "sysrepo";
    platforms = platforms.all;
  };
}
