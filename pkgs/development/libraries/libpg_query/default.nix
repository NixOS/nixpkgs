<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, which, squawk }:

stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "15-4.2.3";
=======
{ lib, stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "15-4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pganalyze";
    repo = "libpg_query";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-/HUg6x0il5WxENmgR3slu7nmXTKv6YscjpX569Dztko=";
=======
    hash = "sha256-2fPdvsfuXKaRwkPjsPsBBfP0+yUgYXEUzQNFZfhyvGk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.tests = {
    inherit squawk;
  };

  meta = with lib; {
    homepage = "https://github.com/pganalyze/libpg_query";
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    changelog = "https://github.com/pganalyze/libpg_query/blob/${version}/CHANGELOG.md";
=======
  meta = with lib; {
    homepage = "https://github.com/pganalyze/libpg_query";
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    changelog = "https://github.com/pganalyze/libpg_query/raw/${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.marsam ];
  };
}
