{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "pipes";
  version = "2017-12-02";

  src = fetchFromGitHub {
    owner = "QuentinDuval";
    repo = "IdrisPipes";
    rev = "888abe405afce42015014899682c736028759d42";
    sha256 = "1dxbqzg0qy7lkabmkj0qypywdjz5751g7h2ql8b2253dy3v0ndbs";
  };

  meta = with lib; {
    description = "Composable and effectful production, transformation and consumption of streams of data";
    homepage = "https://github.com/QuentinDuval/IdrisPipes";
    license = licenses.bsd3;
    maintainers = [ maintainers.brainrape ];
  };
}
