{
  buildPecl,
  lib,
  pkgs,
}:

let
  # parallel requires ZTS support
  php = pkgs.php.override { ztsSupport = true; };
in
(buildPecl.override { php = php.unwrapped; }) {
  pname = "parallel";
  version = "1.2.4";
  hash = "sha256-s9W9aZpQsJLdzZ/d2E1iGDsMTAAjeWbOgWeKP6nNp0A=";

  meta = {
    description = "Parallel concurrency API";
    homepage = "https://pecl.php.net/package/parallel";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
  };
}
