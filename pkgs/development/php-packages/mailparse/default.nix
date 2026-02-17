{
  buildPecl,
  lib,
  php,
}:

buildPecl {
  pname = "mailparse";

  version = "3.1.9";
  hash = "sha256-7LPTydyffOA0GC1Hi3JKw8sCCY78aaOcA1NPCxkgkis=";

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
