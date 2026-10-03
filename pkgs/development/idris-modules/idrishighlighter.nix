{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lightyear,
  lib,
}:
build-idris-package {
  pname = "idrishighlighter";
  version = "2018-02-22";

  ipkgName = "idris-code-highlighter";
  idrisDeps = [
    effects
    lightyear
  ];

  src = fetchFromGitHub {
    owner = "david-christiansen";
    repo = "idris-code-highlighter";
    rev = "708a29c7d1433adf7b0f69d1aec50e69b2915bba";
    hash = "sha256-hT+p2Sg1Zhb0CL4Jk4S0b36bftEkYSlJ/PzAL4X7UJk=";
  };

  meta = {
    description = "Semantic highlighter for Idris code";
    homepage = "https://github.com/david-christiansen/idris-code-highlighter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
