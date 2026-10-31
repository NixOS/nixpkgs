{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
}:
build-idris-package {
  pname = "specdris";
  version = "2018-01-23";

  src = fetchFromGitHub {
    owner = "pheymann";
    repo = "specdris";
    rev = "625f88f5e118e53f30bcf5e5f3dcf48eb268ac21";
    hash = "sha256-SrtjKkBpwPD79S3fW7p3uIV1KubFf4VVOf9E4voJh70=";
  };

  idrisDeps = [ effects ];

  # tests use a different ipkg and directory structure
  doCheck = false;

  meta = {
    description = "Testing library for Idris";
    homepage = "https://github.com/pheymann/specdris";
    license = lib.licenses.mit;
  };
}
