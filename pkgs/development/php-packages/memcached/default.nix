{ buildPecl, lib, fetchgit, php, pkgs }:
let
  pname = "memcached";
  version = "3.1.5";
in
buildPecl {
  inherit pname version;

  src = fetchgit {
    url = "https://github.com/php-memcached-dev/php-memcached";
    rev = "v${version}";
    sha256 = "01mbh2m3kfbdvih3c8g3g9h4vdd80r0i9g2z8b3lx3mi8mmcj380";
  };

  internalDeps = [
    php.extensions.session
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    php.extensions.hash
  ];

  configureFlags = [
    "--with-zlib-dir=${pkgs.zlib.dev}"
    "--with-libmemcached-dir=${pkgs.libmemcached}"
  ];

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = with pkgs; [ cyrus_sasl zlib ];

  meta.maintainers = lib.teams.php.members;
}
