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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "php-memcached-dev";
    repo = "php-memcached";
    rev = "v${version}";
    sha256 = "sha256-V4d6bY0m1nuEfjZjt3qio4/HOBcSlD9+XMEl1GPfbhs=";
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
    maintainers = lib.teams.php.members;
  };
}
