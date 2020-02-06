{ build-idris-package
, fetchFromGitHub
, contrib
, lib
}:
build-idris-package  {
  name = "tparsec";
  version = "2019-09-19";

  ipkgName = "TParsec";
  
  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "cbaea6ec7e5b62536666329940f3ffb5b8b59036";
    sha256 = "0bzdv90a83irn7ca268acl19mjg9vxjmc4saa4naj4hdmg7srb2v";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
