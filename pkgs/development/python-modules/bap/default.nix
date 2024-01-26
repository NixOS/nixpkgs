{lib, buildPythonPackage, fetchFromGitHub, bap, requests}:

buildPythonPackage rec {
  pname = "bap";
  version = "1.3.1";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-python";
    rev = version;
    sha256 = "1ahkrmcn7qaivps1gar8wd9mq2qqyx6zzvznf5r9rr05h17x5lbp";
  };

  propagatedBuildInputs = [bap requests];

  doCheck = false;

  meta = with lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
