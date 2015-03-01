{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass";
    rev = version;
    sha256 = "1k9a6hiybqk7xx4k2cb9vhdqskrrzhi60dvwp3gx39jhjqjfl96p";
  };

  preConfigure = ''
    autoreconf --force --install
  '';

  buildInputs = [ autoconf automake libtool ];

  meta = with lib; {
    description = "A C/C++ implementation of a Sass compiler";
    license = licenses.mit;
    homepage = https://github.com/sass/libsass;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
