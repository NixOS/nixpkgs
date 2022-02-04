{ buildPecl, lib, fetchFromGitHub }:

buildPecl rec {
  pname = "xdebug";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    sha256 = "sha256-4KmFlbs5nluJfKLbIcpVeArlaimyd5JjZEJ2Vj5NlBE=";
  };

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta = with lib; {
    description = "Provides functions for function traces and profiling";
    license = licenses.php301;
    homepage = "https://xdebug.org/";
    maintainers = teams.php.members;
  };
}
