{ stdenv, fetchFromGitHub, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "0.99.8";
  name = "fastjson-${version}";
  src = fetchFromGitHub {
    repo = "libfastjson";
    owner = "rsyslog";
    rev = "v${version}";
    sha256 = "0qhs0g9slj3p0v2z4s3cnsx44msrlb4k78ljg7714qiziqbrbwyl";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    sh autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A fast json library for C";
    homepage = https://github.com/rsyslog/libfastjson;
    license = licenses.mit;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
  };
}
