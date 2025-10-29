{
  buildPecl,
  lib,
  php,
}:

buildPecl {
  pname = "mailparse";

  version = "3.1.8";
  hash = "sha256-Wb6rTvhRdwxJW6egcmq0DgmBNUaaEdnI5mWwiclu/C8=";

  internalDeps = [ php.extensions.mbstring ];
  postConfigure = ''
    echo "#define HAVE_MBSTRING 1" >> config.h
  '';

  meta = with lib; {
    description = "Mailparse is an extension for parsing and working with email messages";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/mailparse";
    teams = [ lib.teams.php ];
  };
}
