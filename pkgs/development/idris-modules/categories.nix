{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "categories";
  version = "2018-07-02";

  src = fetchFromGitHub {
    owner = "danilkolikov";
    repo = "categories";
    rev = "a1e0ac0f0da2e336a7d3900051892ff7ed504c35";
    hash = "sha256-wjmuGkIzrmPbrJnmzoKuhqfBBja8NdUm46UVFz+qda0=";
  };

  meta = {
    description = "Category Theory";
    homepage = "https://github.com/danilkolikov/categories";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
