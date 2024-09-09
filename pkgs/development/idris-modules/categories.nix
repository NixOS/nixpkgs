{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "categories";
  version = "2018-07-02";

  src = fetchFromGitHub {
    owner = "danilkolikov";
    repo = "categories";
    rev = "a1e0ac0f0da2e336a7d3900051892ff7ed504c35";
    sha256 = "1bbmm8zif5d5wckdaddw6q3c39w6ms1cxrlrmkdn7bik88dawff2";
  };

  meta = {
    description = "Category Theory";
    homepage = "https://github.com/danilkolikov/categories";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
