{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  numpy,
  scipy,
  matplotlib,

  python,
}:
buildPythonPackage {
  pname = "heartpy";
  version = "1.2.5-unstable-2025-12-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paulvangentcom";
    repo = "heartrate_analysis_python";
    rev = "ef48d23b73d216cf81c558ad427cd938a5d2f319";
    hash = "sha256-BTSO3oBpXasQ35mOh2pYT4EwScia9utb1LmzY3lAnM8=";
  };

  patches = [ ./fix-doctests.patch ];

  build-system = [ setuptools ];
  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  pythonImportsCheck = [ "heartpy" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  meta = {
    description = "Heart Rate Analysis Toolkit, for both PPG and ECG signals";
    homepage = "https://github.com/paulvangentcom/heartrate_analysis_python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
