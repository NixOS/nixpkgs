{ lib, buildNimPackage, fetchFromGitHub }:
buildNimPackage rec {
  pname = "safeseq";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JSz2TPrbl5N8l+YDquad78aJMBsx+Lise27cMQKMdAc=";
  };


  meta = with lib;
    src.meta // {
      description = "safeseq library for nim";
      license = [ licenses.gpl2 ];
      maintainers = [ maintainers.marcusramberg ];
    };
}
