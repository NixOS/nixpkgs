{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  oldest-supported-numpy,
  setuptools,
  wheel,
  scipy,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dtw-python";
  version = "1.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "DynamicTimeWarping";
    repo = "dtw-python";
    tag = "v${version}";
    hash = "sha256-DaYqKvjbp2yjL0a5f+vkB4OFOCWqt+f1HUUfarbns3A=";
  };

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    scipy
    numpy
  ];

  # We need to run tests on real built package: https://github.com/NixOS/nixpkgs/issues/255262
  # tests/ are not included to output package, so we have to set path explicitly
  preCheck = ''
    appendToVar enabledTestPaths "$src/tests"
    cd $out
  '';
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dtw" ];

  meta = with lib; {
    description = "Python port of R's Comprehensive Dynamic Time Warp algorithms package";
    mainProgram = "dtw";
    homepage = "https://github.com/DynamicTimeWarping/dtw-python";
    changelog = "https://github.com/DynamicTimeWarping/dtw-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
