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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "PyDMD";
    rev = "v${version}";
    sha256 = "1516dhmpwi12v9ly9jj18wpz9k696q5k6aamlrbby8wp8smajgrv";
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
