{ buildPecl, lib, pcre2, fetchFromGitHub }:

buildPecl rec {
  pname = "pcov";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "pcov";
    rev = "v${version}";
    sha256 = "sha256-lyY17Y9chpTO8oeWmDGSh0YSnipYqCuy1qmn9su5Eu8=";
  };

  buildInputs = [ pcre2 ];

  meta = with lib; {
    description = "A self contained php-code-coverage compatible driver for PHP.";
    license = licenses.php301;
    homepage = "https://github.com/krakjoe/pcov";
    maintainers = teams.php.members;
  };
}
