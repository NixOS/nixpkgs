{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python2, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "0g4029s8b1gfpl1ryxf1i7gp3gwn11isr61qkb8zy9kv904pcc89";
  };

  nativeBuildInputs = [ gnused python2 ];
  buildInputs = [ postgresql doxygen xmlto ];

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--enable-shared" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = http://pqxx.org/development/libpqxx/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}
