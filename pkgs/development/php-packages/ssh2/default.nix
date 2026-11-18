{
  buildPecl,
  lib,
  libssh2,
}:

buildPecl rec {
  version = "1.6.1";
  pname = "ssh2";

  sha256 = "sha256-IhLYJm31RlSygspoHum4LzEqd26AG2Z7KI2A81QXQe0=";

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
