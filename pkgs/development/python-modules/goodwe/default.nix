{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "goodwe";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = "goodwe";
    rev = "refs/tags/v${version}";
    hash = "sha256-0N2aimDj9HF0y1pitg7E2OzGk4o4kopSlvXy9x6jplk=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "'marcelblijleven@gmail.com" "marcelblijleven@gmail.com" \
      --replace-fail "version: file: VERSION" "version = ${version}"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "goodwe" ];

  meta = with lib; {
    description = "Python library for connecting to GoodWe inverter";
    homepage = "https://github.com/marcelblijleven/goodwe";
    changelog = "https://github.com/marcelblijleven/goodwe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
