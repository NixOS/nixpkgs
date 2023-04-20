{ buildPecl, lib, fetchFromGitHub }:

let
  version = "3.2.1";
in buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    sha256 = "sha256-WKvMnn8yp6JBFu7xzPOt6sdg5JE8SRniLZbSBvi3ecQ=";
  };

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta = with lib; {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    license = licenses.php301;
    homepage = "https://xdebug.org/";
    maintainers = teams.php.members;
  };
}
