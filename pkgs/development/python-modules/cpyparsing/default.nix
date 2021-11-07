{ lib, buildPythonPackage, fetchFromGitHub, cython, pexpect, python }:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.1.0.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "09073751d92cb40fb71c927c006baddc082df1db"; # No tags on repo
    sha256 = "O9IdHipAxxbFcDFYNvmczue/wT4AF9Xb5uc3ZTAlTlo=";
  };

  nativeBuildInputs = [ cython ];

  checkInputs = [ pexpect ];

  checkPhase = "${python.interpreter} tests/cPyparsing_test.py";

  meta = with lib; {
    homepage = "https://github.com/evhub/cpyparsing";
    description = "Cython PyParsing implementation";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
