{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:
build-idris-package  {
  name = "categories";
  version = "2017-03-01";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "danilkolikov";
    repo = "categories";
    rev = "933fe418d154e10df39ddb09a74419cb4c4a57e8";
    sha256 = "1dmpcv13zh7j4k6s2nlpf08gmpawaqaqkbqbg8zrgw253piwb0ci";
  };

  meta = {
    description = "Category Theory";
    homepage = https://github.com/danilkolikov/categories;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
