{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bap,
  requests,
}:

buildPythonPackage rec {
  pname = "bap";
  version = "1.3.1";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-python";
    rev = version;
    sha256 = "1ahkrmcn7qaivps1gar8wd9mq2qqyx6zzvznf5r9rr05h17x5lbp";
  };

  build-system = [ setuptools ];

  dependencies = [
    bap
    requests
  ];

  doCheck = false;

  meta = {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    maintainers = [ lib.maintainers.maurer ];
    license = lib.licenses.mit;
  };
}
