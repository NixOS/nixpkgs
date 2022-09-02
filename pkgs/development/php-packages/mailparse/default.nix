{ buildPecl, lib, php }:

buildPecl {
  pname = "mailparse";

  version = "3.1.3";
  sha256 = "sha256-hlnKYtyaTX0V8H+XoOIULLWCUcjncs02Zp7HQNIpJHE=";

  internalDeps = [ php.extensions.mbstring ];
  postConfigure = ''
    echo "#define HAVE_MBSTRING 1" >> config.h
  '';

  meta = with lib; {
    description = "Mailparse is an extension for parsing and working with email messages";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/mailparse";
    maintainers = lib.teams.php.members;
  };
}
