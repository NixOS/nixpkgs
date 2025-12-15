{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage {
  pname = "fullmoon";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jr-k";
    repo = "python-fullmoon";
    rev = "702b94d9924cce8c156a3d7951bea65b19022358";
    hash = "sha256-d0OL5z2DCOp0xSYBAdaMHZV9wmZJ6jiQTl7NZjMYJRA=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    python example.py
    runHook postCheck
  '';

  meta = {
    description = "Determine the occurrence of the next full moon or to determine if a given date is/was/will be a full moon";
    homepage = "https://github.com/jr-k/python-fullmoon";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
