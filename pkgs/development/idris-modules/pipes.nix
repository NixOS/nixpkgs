{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package  {
  name = "pipes";
  version = "2017-12-02";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "QuentinDuval";
    repo = "IdrisPipes";
    rev = "888abe405afce42015014899682c736028759d42";
    sha256 = "1dxbqzg0qy7lkabmkj0qypywdjz5751g7h2ql8b2253dy3v0ndbs";
  };

  meta = {
    description = "Composable and effectful production, transformation and consumption of streams of data";
    homepage = https://github.com/QuentinDuval/IdrisPipes;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
