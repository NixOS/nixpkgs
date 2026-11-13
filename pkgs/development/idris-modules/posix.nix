{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "posix";
  version = "2017-11-18";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "idris-posix";
    rev = "1e4787bc4dfcf901f2e1858e5334a6bafa5d27c4";
    hash = "sha256-q+q3MqKZeYy8Y4gDsBwWwF0uZR5jjfhMmUNsFOwOxZM=";
  };

  # tests need file permissions
  doCheck = false;

  meta = {
    description = "System POSIX bindings for Idris";
    homepage = "https://github.com/idris-hackers/idris-posix";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
