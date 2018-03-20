{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, test
, lib
, idris
}:

build-idris-package  {
  name = "containers";
  version = "2017-09-10";

  idrisDeps = [ prelude effects test ];

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-containers";
    rev = "fb96aaa3f40faa432cd7a36d956dbc4fe9279234";
    sha256 = "0vyjadd9sb8qcbzvzhnqwc8wa7ma770c10xhn96jsqsnzr81k52d";
  };

  postUnpack = ''
    rm source/containers-travis.ipkg
  '';

  meta = {
    description = "Various data structures for use in the Idris Language.";
    homepage = https://github.com/jfdm/idris-containers;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
