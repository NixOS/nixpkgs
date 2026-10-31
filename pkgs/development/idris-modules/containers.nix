{
  build-idris-package,
  fetchFromGitHub,
  effects,
  test,
  lib,
}:
build-idris-package {
  pname = "containers";
  version = "2017-09-10";

  idrisDeps = [
    effects
    test
  ];

  src = fetchFromGitHub {
    owner = "jfdm";
    repo = "idris-containers";
    rev = "fb96aaa3f40faa432cd7a36d956dbc4fe9279234";
    hash = "sha256-TZQZUP5WYy1NsrCDwMA5qh7FEePYwr//YhgtnVpT0m8=";
  };

  meta = {
    description = "Various data structures for use in the Idris Language";
    homepage = "https://github.com/jfdm/idris-containers";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
