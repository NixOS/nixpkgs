{ lib, stdenv, fetchFromGitHub, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "0.99.9";
  pname = "fastjson";
  src = fetchFromGitHub {
    repo = "libfastjson";
    owner = "rsyslog";
    rev = "v${version}";
    sha256 = "sha256-2LyBdJR0dV1CElcGfrlmNwX52lVtx9X/Z4h/1XFjOIs=";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool ];

  preConfigure = ''
    sh autogen.sh
  '';

  meta = with lib; {
    description = "A fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = licenses.mit;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
  };
}
