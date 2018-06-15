{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lib
, idris
}:
build-idris-package  {
  name = "heyting-algebra";
  version = "2017-08-18";

  idrisDeps = [ prelude contrib ];

  src = fetchFromGitHub {
    owner = "Risto-Stevcev";
    repo = "idris-heyting-algebra";
    rev = "2c814c48246a5e19bff66e64a753208c7d59d397";
    sha256 = "199cvhxiimlhchvsc66zwn0dls78f9lamam256ad65mv4cjmxv40";
  };

  meta = {
    description = "Interfaces for heyting algebras and verified bounded join and meet semilattices";
    homepage = https://github.com/Risto-Stevcev/idris-heyting-algebra;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
