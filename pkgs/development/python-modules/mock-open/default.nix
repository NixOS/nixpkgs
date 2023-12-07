{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, pythonOlder, mock }:

buildPythonPackage rec {
  pname = "mock-open";
  version = "1.4.0";
  format = "setuptools";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "nivbend";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qlz4y8jqxsnmqg03yp9f87rmnjrvmxm5qvm6n1218gm9k5dixbm";
  };

  patches = lib.optional (pythonOlder "3.0")
    (fetchpatch {
      name = "ascii-only.patch";
      url = "https://github.com/das-g/mock-open/commit/521ff260da127949fe4aceff1667cba223c5b07b.patch";
      sha256 = "0ampbhk7kwkn0q5d2h9wrflkr8fji2bybmdck4qdzw1qkslfwwrn";
    });

  propagatedBuildInputs = lib.optional (pythonOlder "3.3") mock;

  meta = with lib; {
    homepage = "https://github.com/nivbend/mock-open";
    description = "A better mock for file I/O";
    license = licenses.mit;
  };
}
