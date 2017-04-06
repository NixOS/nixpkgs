{stdenv, buildPythonPackage, fetchFromGitHub, bap, requests}:

buildPythonPackage rec {
  name = "bap";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-python";
    rev = "v${version}";
    sha256 = "0wd46ksxscgb2dci69sbndzxs6drq5cahraqq42cdk114hkrsxs3";
  };

  propagatedBuildInputs = [bap requests];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = https://github.com/BinaryAnalysisPlatform/bap/;
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
