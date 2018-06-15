{ build-idris-package
, fetchFromGitHub
, prelude
, bifunctors
, lib
, idris
}:

build-idris-package  {
  name = "lens";
  version = "2017-09-25";

  idrisDeps = [ prelude bifunctors ];

  src = fetchFromGitHub {
    owner = "HuwCampbell";
    repo = "idris-lens";
    rev = "421aa76c19607693ac2f23003dc0fe82c1a3760a";
    sha256 = "1q6lmhrwd1qg18s253sim4hg2a2wk5439p3izy1f9ygi6pv4a6mk";
  };

  meta = {
    description = "van Laarhoven lenses for Idris";
    homepage = https://github.com/HuwCampbell/idris-lens;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
