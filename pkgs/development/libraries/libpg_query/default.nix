{ lib, stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "15-4.1.0";

  src = fetchFromGitHub {
    owner = "pganalyze";
    repo = "libpg_query";
    rev = version;
    hash = "sha256-uZdszDE0UJVeegU1bi0ISYooC4ztNv7W4UQ2gWIjrH8=";
  };

  nativeBuildInputs = [ which ];

  makeFlags = [ "build" ];

  installPhase = ''
    install -Dm644 -t $out/lib libpg_query.a
    install -Dm644 -t $out/include pg_query.h
  '';

  meta = with lib; {
    homepage = "https://github.com/pganalyze/libpg_query";
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    changelog = "https://github.com/pganalyze/libpg_query/raw/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.marsam ];
  };
}
