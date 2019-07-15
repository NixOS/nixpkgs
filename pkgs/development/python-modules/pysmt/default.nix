{ buildPythonPackage
, fetchFromGitHub
, lib
, nose
, six
}:

buildPythonPackage rec {
  pname = "PySMT";
  version = "0.8.0";

  propagatedBuildInputs = [ six ];

  src = fetchFromGitHub {
    owner = "pysmt";
    repo = "pysmt";
    rev = "v${version}";
    sha256 = "1s06vq06x4sm84016vsq7bb74d0wkia4193wzxqzs9pmlqwpjnrf";
  };

  checkInputs = [ nose ];

  meta = with lib; {
    description = "A solver-agnostic library for SMT Formulae manipulation and solving";
    homepage = "https://github.com/pysmt/pysmt";
    license = licenses.asl20;
    maintainers = [ maintainers.pamplemousse ];
  };
}
