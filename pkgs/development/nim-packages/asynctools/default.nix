{ lib, buildNimPackage, fetchFromGitHub, astpatternmatching }:

buildNimPackage rec {
  pname = "asynctools";
  version = "unstable-2021-07-06";

  src = fetchFromGitHub {
    owner = "cheatfate";
    repo = "asynctools";
    rev = "84ced6d002789567f2396c75800ffd6dff2866f7";
    hash = "sha256-mrO+WeSzCBclqC2UNCY+IIv7Gs8EdTDaTeSgXy3TgNM=";
  };

  meta = with lib; {
    description = "Various asynchronous tools for Nim language";
    homepage = "https://github.com/cheatfate/asynctools";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
