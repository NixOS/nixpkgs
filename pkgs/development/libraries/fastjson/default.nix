{ stdenv, fetchFromGitHub, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "v0.99.2";
  name = "fastjson-${version}";
  src = fetchFromGitHub {
    repo = "libfastjson";
    owner = "rsyslog";
    rev = "eabae907c9d991143e17da278a239819f2e8ae1c";
    sha256 = "17fhaqdn0spc4p0848ahcy68swm6l5yd3bx6bdzxmmwj1jdrmvzk";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    sh autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = licenses.mit;
    maintainers = with maintainers; [ nequissimus ];
  };
}
