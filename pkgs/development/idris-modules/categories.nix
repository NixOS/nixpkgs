{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "categories";
  version = "2018-07-02";

  # https://github.com/danilkolikov/categories/pull/5
  src = fetchFromGitHub {
    owner = "infinisil";
    repo = "categories";
    rev = "9722d62297e5025431e91b271ab09c5d14867236";
    sha256 = "1bbmm8zif5d5wckdaddw6q3c39w6ms1cxrlrmkdn7bik88dawff2";
  };

  meta = {
    description = "Category Theory";
    homepage = https://github.com/danilkolikov/categories;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
