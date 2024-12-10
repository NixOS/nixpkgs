{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.7.5";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "sha256-mvGPMbk4b8NmPvzy5hS+Au69NtDGha8ONTEQf6I3VZE=";
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
