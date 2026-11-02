{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "bifunctors";
  version = "2017-02-07";

  src = fetchFromGitHub {
    owner = "japesinator";
    repo = "Idris-Bifunctors";
    rev = "be7b8bde88331ad3af87e5c0a23fc0f3d52f3868";
    hash = "sha256-2BsVc2lYC+ebTTTq8rYXlpCFw4EVrJt3eOCJCikq1zE=";
  };

  meta = {
    description = "Small bifunctor library for idris";
    homepage = "https://github.com/japesinator/Idris-Bifunctors";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
