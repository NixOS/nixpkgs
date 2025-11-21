{
  buildPecl,
  lib,
  libssh2,
}:

buildPecl rec {
  version = "1.4.1";
  pname = "ssh2";

  sha256 = "sha256-e8pbI/cx252O0K6l25uxXaj/EzsPu6lhArguldpNh2Q=";

  buildInputs = [ libssh2 ];
  configureFlags = [ "--with-ssh2=${libssh2.dev}" ];

  meta = {
    changelog = "https://pecl.php.net/package-info.php?package=ssh2&version=${version}";
    description = "PHP bindings for the libssh2 library";
    license = lib.licenses.php301;
    homepage = "https://github.com/php/pecl-networking-ssh2";
    maintainers = [ lib.maintainers.ostrolucky ];
    teams = [ lib.teams.php ];
  };
}
