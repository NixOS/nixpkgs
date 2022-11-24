{ lib, stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "13-2.2.0";

  src = fetchFromGitHub {
    owner = "pganalyze";
    repo = "libpg_query";
    rev = version;
    sha256 = "sha256-gEkcv/j8ySUYmM9lx1hRF/SmuQMYVHwZAIYOaCQWAFs=";
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
