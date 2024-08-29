{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fireflyalgorithm";
  version = "0.4.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "FireflyAlgorithm";
    rev = "refs/tags/${version}";
    hash = "sha256-dJnjeJN9NI8G/haYeOiMtAl56cExqMk0iTWpaybl4nE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fireflyalgorithm" ];

  meta = with lib; {
    description = "Implementation of the stochastic nature-inspired algorithm for optimization";
    mainProgram = "firefly-algorithm";
    homepage = "https://github.com/firefly-cpp/FireflyAlgorithm";
    changelog = "https://github.com/firefly-cpp/FireflyAlgorithm/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
