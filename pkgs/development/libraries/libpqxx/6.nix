{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  doxygen,
  xmlto,
  python3,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "6.4.8";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    hash = "sha256-ybnW9ip1QVadmbYLP+gvo49k9ExHfnsOhSnI6NjsAQk=";
  };

  nativeBuildInputs = [
    gnused
    python3
  ];
  buildInputs = [
    postgresql
    doxygen
    xmlto
  ];

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--enable-shared" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
  };
}
