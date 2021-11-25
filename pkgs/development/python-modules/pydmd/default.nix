{ lib
, stdenv
, python
, fetchFromGitHub
, buildPythonPackage
, future
, numpy
, scipy
, matplotlib
, nose
}:

buildPythonPackage rec {
  pname = "pydmd";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "PyDMD";
    rev = "v${version}";
    sha256 = "1qwa3dyrrm20x0pzr7rklcw7433fd822n4m8bbbdd7z83xh6xm8g";
  };

  propagatedBuildInputs = [ future numpy scipy matplotlib ];
  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';
  pythonImportsCheck = [ "pydmd" ];

  meta = {
    description = "Python Dynamic Mode Decomposition";
    homepage = "https://mathlab.github.io/PyDMD/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
    broken = stdenv.hostPlatform.isAarch64;
  };
}
