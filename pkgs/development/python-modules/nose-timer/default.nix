{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose,
  mock,
  parameterized,
  termcolor,
}:

buildPythonPackage rec {
  pname = "nose-timer";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mahmoudimus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xsai2l5i1av62y9y0q63wy2zk27klmf2jizgghhxg2y8nfa8x3x";
  };

  propagatedBuildInputs = [ nose ];

  nativeCheckInputs = [
    mock
    nose
    parameterized
    termcolor
  ];

  checkPhase = ''
    runHook preCheck
    nosetests --verbosity 2 tests
    runHook postCheck
  '';

  pythonImportsCheck = [ "nosetimer" ];

  meta = with lib; {
    description = "A timer plugin for nosetests";
    homepage = "https://github.com/mahmoudimus/nose-timer";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
