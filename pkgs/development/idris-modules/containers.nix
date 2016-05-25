{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, test
, lib
, idris
}: build-idris-package {
  name = "containers";

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-containers";
    rev = "4a7c1c3b84bf9eab956fdc5b5c19728b6b290aeb";
    sha256 = "09bs9q0hhij455vs14ys8bj6p3ydkx65ymprq7aql6zlh0c86gb8";
  };

  propagatedBuildInputs = [ prelude base effects test ];

  meta = {
    description = "Various data structures for use in Idris";
    homepage = https://github.com/ziman/lightyear;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
