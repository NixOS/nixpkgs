{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aqipy-atmotech";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atmotube";
    repo = "aqipy";
    tag = finalAttrs.version;
    hash = "sha256-tqHhfJmtVFUSO57Cid9y3LK4pOoG7ROtwDT2hY5IE1Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  pythonImportsCheck = [ "aqipy" ];

  meta = {
    description = "Library for AQI calculation";
    homepage = "https://github.com/atmotube/aqipy";
    changelog = "https://github.com/atmotube/aqipy/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
