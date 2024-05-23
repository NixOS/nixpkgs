{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

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

  meta = with lib; {
    homepage = "https://github.com/nivbend/mock-open";
    description = "A better mock for file I/O";
    license = licenses.mit;
  };
}
