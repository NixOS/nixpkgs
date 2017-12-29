{ stdenv, fetchFromGitHub, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "v0.99.4";
  name = "fastjson-${version}";
  src = fetchFromGitHub {
    repo = "libfastjson";
    owner = "rsyslog";
    rev = "6e057a094cb225c9d80d8d6e6b1f36ca88a942dd";
    sha256 = "1pn207p9zns0aqm6z5l5fdgb94wyyhaw83lyvyfdxmai74nbqs65";
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
