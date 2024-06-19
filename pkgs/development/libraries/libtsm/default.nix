{ lib, stdenv, fetchFromGitHub, libxkbcommon, pkg-config, cmake }:

stdenv.mkDerivation rec {
  pname = "libtsm";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "libtsm";
    rev = "v${version}";
    sha256 = "sha256-BYMRPjGRVSnYzkdbxypkuE0YkeVLPJ32iGZ1b0R6wto=";
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [ cmake pkg-config ];

  # https://github.com/Aetf/libtsm/issues/20
  postPatch = ''
    substituteInPlace etc/libtsm.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
