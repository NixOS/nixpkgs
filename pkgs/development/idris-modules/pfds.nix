{ build-idris-package
, fetchFromGitHub
, contrib
, lib
}:
build-idris-package  {
  pname = "pfds";
  version = "2017-09-25";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "timjb";
    repo = "idris-pfds";
    rev = "9ba39348adc45388eccf6463855f42b81333620a";
    sha256 = "0jbrwdpzg5hgmkfk2kj5y8lgaynl79h48qdvkl1glypfh392w35f";
  };

  meta = {
    description = "Purely functional data structures in Idris";
    homepage = "https://github.com/timjb/idris-pfds";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
