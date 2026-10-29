{
  build-idris-package,
  fetchFromGitHub,
  bifunctors,
  lib,
}:
build-idris-package {
  pname = "yampa";
  version = "2016-07-05";

  ipkgName = "idris-yampa";
  idrisDeps = [ bifunctors ];

  src = fetchFromGitHub {
    owner = "BartAdv";
    repo = "idris-yampa";
    rev = "2120dffb3ea0de906ba2b40080956c900457cf33";
    hash = "sha256-prMIO+Z0xQ16QLk9wDAZdX1RzIsxvZp/e0rvdX9J5H4=";
  };

  meta = {
    description = "Idris implementation of Yampa FRP library as described in Reactive Programming through Dependent Types";
    homepage = "https://github.com/BartAdv/idris-yampa";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
