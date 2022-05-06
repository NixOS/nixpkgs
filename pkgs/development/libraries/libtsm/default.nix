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

  meta = with lib; {
    description = "Terminal-emulator State Machine";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux;
  };
}
