{ lib, buildPythonPackage, fetchPypi, python3Packages }:
buildPythonPackage rec {
  pname = "js2py";
  version = "0.71";

  src = fetchPypi {
    inherit version;
    pname = "Js2Py";
    sha256 = "sha256-pBsQCd0UmK59Q2v6WslSoIypKku54x3Kbou5ZrSff84=";
  };

  propagatedBuildInputs = with python3Packages; [ six pyjsparser tzlocal ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage =
      "JavaScript to Python Translator & JavaScript interpreter written in 100% pure Python";
    description =
      "JavaScript to Python Translator & JavaScript interpreter written in 100% pure Python";
    license = licenses.mit;
    maintainers = [ payas ];
  };
}
