{ lib, stdenv, fetchFromGitHub, postgresql, python3 }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.8.1";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "sha256-1afp9SPFolxchWv+2MjytvucUdX/cUXO5TWe7pUnL10=";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [ postgresql ];

  preConfigure = ''
    patchShebangs ./tools/splitconfig
  '';

  configureFlags = [ "--enable-shared --disable-documentation" ];
  CXXFLAGS = [ "-std=c++17" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
  };
}
