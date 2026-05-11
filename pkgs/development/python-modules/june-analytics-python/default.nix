{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dateutils,
  requests,
  monotonic,
  backoff,
  unittestCheckHook,
}:

buildPythonPackage {
  pname = "june-analytics-python";
  version = "unstable-2022-07-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juneHQ";
    repo = "analytics-python";
    rev = "462b523a617fbadc016ace45e6eec5762a8ae45f";
    hash = "sha256-9IcikYQW1Q3aAyjIZw6UltD6cYFE+tBK+/EMQpRGCoQ=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    dateutils
    requests
    monotonic
    backoff
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "june" ];

  pythonImportsCheck = [ "june" ];

  meta = {
    description = "Hassle-free way to integrate analytics into any python application";
    homepage = "https://github.com/juneHQ/analytics-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
