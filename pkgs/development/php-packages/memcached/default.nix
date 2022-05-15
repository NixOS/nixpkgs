{ buildPecl, lib, fetchFromGitHub, php, cyrus_sasl, zlib, pkg-config, libmemcached }:

buildPecl rec {
  pname = "memcached";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "php-memcached-dev";
    repo = "php-memcached";
    rev = "v${version}";
    sha256 = "sha256-g9IzGSZUxLlOE32o9ZJOa3erb5Qs1ntR8nzS3kRd/EU=";
  };

  internalDeps = [
    php.extensions.session
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
