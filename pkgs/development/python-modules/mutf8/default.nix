{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutf8";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = "mutf8";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vtfdik+g2jnadslfthGXJWJidzR1BJibod10Wla6lSg=";
  };

  __structuredAttrs = true;

  pyproject = true;
  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    runHook preCheck
    # Using pytestCheckHook results in test failures
    pytest
    runHook postCheck
  '';

  pythonImportsCheck = [ "mutf8" ];

  meta = {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
