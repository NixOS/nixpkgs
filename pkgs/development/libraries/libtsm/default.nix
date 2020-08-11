{ stdenv, fetchFromGitHub, libxkbcommon, pkgconfig, cmake }:

stdenv.mkDerivation rec {
  pname = "libtsm";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "libtsm";
    rev = "v${version}";
    sha256 = "0mwn91i5h5d518i1s05y7hzv6bc13vzcvxszpfh77473iwg4wprx";
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "Terminal-emulator State Machine";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
