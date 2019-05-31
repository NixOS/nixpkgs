{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python2, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "6.4.4";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "0l62qlln5q1qhapbnm8n1k0hbzf3287gld1jpcbwr0yj79l9j579";
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
