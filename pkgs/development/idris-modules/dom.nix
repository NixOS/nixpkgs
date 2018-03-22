{ build-idris-package
, fetchFromGitHub
, prelude
, idrisscript
, html
, xhr
, lib
, idris
}:
build-idris-package  {
  name = "dom";
  version = "2017-04-22";

  idrisDeps = [ prelude idrisscript html xhr ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-dom";
    rev = "6e5a2d143f62ef422358924ee7db6e8147cdc531";
    sha256 = "16z9mykw2d9rjikn07kd6igb53jgaqi8zby4nc4n0gmplmhwdx4x";
  };

  meta = {
    description = "Idris library to interact with the DOM";
    homepage = https://github.com/pierrebeaucamp/idris-dom;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
