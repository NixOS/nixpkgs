{
  buildPecl,
  lib,
  php,
}:

buildPecl {
  pname = "mailparse";

  version = "3.2.0";
  hash = "sha256-zFERrhe/o278xe8j3PdbZQFZOsJkwZaq0+Oc1K12UzI=";

  internalDeps = [ php.extensions.mbstring ];
  postConfigure = ''
    echo "#define HAVE_MBSTRING 1" >> config.h
  '';

  meta = {
    description = "Mailparse is an extension for parsing and working with email messages";
    license = lib.licenses.php301;
    homepage = "https://pecl.php.net/package/mailparse";
    teams = [ lib.teams.php ];
  };
}
