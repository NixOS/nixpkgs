{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "permutations";
  version = "2018-01-19";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "permutations";
    rev = "f0de6bc721bb9d31e16f9168ded6eb6e34935881";
    sha256 = "1dirzqy40fczbw7gp2jr51lzqsnq5vcx9z5l6194lcrq2vxgzv1s";
  };

  meta = {
    description = "Type-safe way of working with permutations in Idris";
    homepage = "https://github.com/vmchale/permutations";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
