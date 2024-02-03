{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "asciigraph";
  version = "unstable-2021-03-02";

  src = fetchFromGitHub {
    owner = "Yardanico";
    repo = "asciigraph";
    rev = "9f51fc4e94d0960ab63fa6ea274518159720aa69";
    hash = "sha256-JMBAW8hkE2wuXkRt4aHqFPoz1HX1J4SslvcaQXfpDNk";
  };


  meta = with lib;
    src.meta // {
      description = "Console ascii line graphs in pure Nim";
      license = [ licenses.mit ];
      maintainers = with maintainers; [ sikmir ];
    };
}
