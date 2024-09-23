{ build-idris-package
, fetchFromGitHub
, effects
, test
, lib
}:
build-idris-package  {
  pname = "containers";
  version = "2017-09-10";

  idrisDeps = [ effects test ];

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-containers";
    rev = "fb96aaa3f40faa432cd7a36d956dbc4fe9279234";
    sha256 = "0vyjadd9sb8qcbzvzhnqwc8wa7ma770c10xhn96jsqsnzr81k52d";
  };

  meta = {
    description = "Various data structures for use in the Idris Language";
    homepage = "https://github.com/jfdm/idris-containers";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
