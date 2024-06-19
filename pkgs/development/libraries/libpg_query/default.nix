{ lib, stdenv, fetchFromGitHub, which, squawk }:

stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "16-5.1.0";

  src = fetchFromGitHub {
    owner = "pganalyze";
    repo = "libpg_query";
    rev = version;
    hash = "sha256-X48wjKdgkAc4wUubQ5ip1zZYiCKzQJyQTgGvO/pOY3I=";
  };

  nativeBuildInputs = [ which ];

  makeFlags = [ "build" "build_shared" ];

  installPhase = ''
    install -Dm644 -t $out/lib libpg_query.a
    install -Dm644 -t $out/include pg_query.h
    install -Dm644 -t $out/lib libpg_query${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  doCheck = true;
  checkTarget = "test";

  passthru.tests = {
    inherit squawk;
  };

  meta = with lib; {
    homepage = "https://github.com/pganalyze/libpg_query";
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    changelog = "https://github.com/pganalyze/libpg_query/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
