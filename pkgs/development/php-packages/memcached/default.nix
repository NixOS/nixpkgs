{ buildPecl, lib, fetchFromGitHub, php, cyrus_sasl, zlib, pkg-config, libmemcached }:

buildPecl rec {
  pname = "memcached";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "php-memcached-dev";
    repo = "php-memcached";
    rev = "v${version}";
    sha256 = "sha256-AA3JakWxjk7HQl+8FEEGqLVNYHrjITZg3G25OaqAqwY=";
  };

  internalDeps = [
    php.extensions.session
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    php.extensions.hash
  ];

  configureFlags = [
    "--with-zlib-dir=${zlib.dev}"
    "--with-libmemcached-dir=${libmemcached}"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cyrus_sasl zlib ];

  meta = with lib; {
    description = "PHP extension for interfacing with memcached via libmemcached library";
    license = licenses.php301;
    homepage = "https://github.com/php-memcached-dev/php-memcached";
    maintainers = teams.php.members;
  };
}
