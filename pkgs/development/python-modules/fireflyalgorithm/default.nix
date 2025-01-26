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
  version = "0.4.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "FireflyAlgorithm";
    tag = version;
    hash = "sha256-NMmwjKtIk8KR0YXXSXkJhiQsbjMusaLnstUWx0izCNA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy = "^1.26.1"' ""
  '';

  build-system = [ poetry-core ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fireflyalgorithm" ];

  meta = {
    description = "Implementation of the stochastic nature-inspired algorithm for optimization";
    mainProgram = "firefly-algorithm";
    homepage = "https://github.com/firefly-cpp/FireflyAlgorithm";
    changelog = "https://github.com/firefly-cpp/FireflyAlgorithm/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
