{ buildPecl, lib, fetchFromGitHub }:

let
  version = "2.0.1";
in buildPecl {
  inherit version;

  pname = "scrypt";

  src = fetchFromGitHub {
    owner = "DomBlack";
    repo = "php-scrypt";
    rev = "v${version}";
    sha256 = "sha256-JUA8Do43Gmtc0ZWJHBtBzSQ+AhE5nGkiRg8gkVF+Cec=";
  };

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    changelog = "https://github.com/DomBlack/php-scrypt/releases/tag/${version}";
    description = "Provides a wrapper to Colin Percival's scrypt implementation";
    license = licenses.bsd2;
    maintainers = teams.php.members ++ [ maintainers.szucsitg ] ;
  };
}
