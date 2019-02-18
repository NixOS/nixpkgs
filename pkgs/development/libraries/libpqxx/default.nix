{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python2, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "15na6iq4mspfa5vgayqzs0wqkqq9nk23d05qwn6xc3gpna2kyqsv";
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
