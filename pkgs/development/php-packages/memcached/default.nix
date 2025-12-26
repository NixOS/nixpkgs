{
  buildPecl,
  lib,
  fetchFromGitHub,
  php,
  cyrus_sasl,
  zlib,
  pkg-config,
  libmemcached,
}:

buildPecl rec {
  pname = "memcached";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "php-memcached-dev";
    repo = "php-memcached";
    rev = "v${version}";
    sha256 = "sha256-sweEM4TVId+6ySffulmebZpz390dZXb+G3zFZvc45L8=";
  };

  internalDeps = [ php.extensions.session ];

  configureFlags = [
    "--with-zlib-dir=${zlib.dev}"
    "--with-libmemcached-dir=${libmemcached}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cyrus_sasl
    zlib
  ];

  meta = {
    description = "PHP extension for interfacing with memcached via libmemcached library";
    license = lib.licenses.php301;
    homepage = "https://github.com/php-memcached-dev/php-memcached";
    teams = [ lib.teams.php ];
  };
}
