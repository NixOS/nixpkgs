{ lib, buildNimPackage, fetchFromGitHub }:
buildNimPackage rec {
  pname = "safeset";

  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZLdStoNVoQhRkD2iEzKxhs1UPfgnbJM9QCDHdjH7vTU=";
  };


  meta = with lib;
    src.meta // {
      description = "safeset library for nim";
      license = [ licenses.gpl2 ];
      maintainers = [ maintainers.marcusramberg ];
    };
}
