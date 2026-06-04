{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aqipy-atmotech";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atmotube";
    repo = "aqipy";
    rev = version;
    hash = "sha256-tqHhfJmtVFUSO57Cid9y3LK4pOoG7ROtwDT2hY5IE1Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [ "aqipy" ];

  meta = {
    description = "Library for AQI calculation";
    homepage = "https://github.com/atmotube/aqipy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
