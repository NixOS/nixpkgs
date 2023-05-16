{ stdenv
, buildPecl
<<<<<<< HEAD
, fetchFromGitHub
, lib
, libiconv
=======
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pcre2
, pkg-config
, cyrus_sasl
, icu64
, openssl
, snappy
, zlib
, darwin
}:

<<<<<<< HEAD
buildPecl rec {
  pname = "mongodb";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    rev = version;
    hash = "sha256-nVkue3qB6OwXKcyaYU1WmXG7pamKQtk8cbztVVkNejo=";
    fetchSubmodules = true;
  };
=======
buildPecl {
  pname = "mongodb";

  version = "1.15.0";
  sha256 = "sha256-7rYmjTS9C0o9zGDd5OSE9c9PokOco9nwJMAADpnuckA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cyrus_sasl
    icu64
    openssl
    snappy
    zlib
    pcre2
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.Libsystem
    libiconv
  ];

  meta = {
    description = "The Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
=======
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "MongoDB driver for PHP";
    license = licenses.asl20;
    homepage = "https://docs.mongodb.com/drivers/php/";
    maintainers = teams.php.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
