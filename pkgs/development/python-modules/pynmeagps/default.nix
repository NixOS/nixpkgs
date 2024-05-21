{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynmeagps";
  version = "1.0.36";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    rev = "refs/tags/v${version}";
    hash = "sha256-n7dCr85TeBLxdrD1ZAA7PGJd9+3+xFJ8gjRU/JOFysY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov --cov-report html --cov-fail-under 95" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynmeagps" ];

  meta = {
    description = "NMEA protocol parser and generator";
    homepage = "https://github.com/semuconsulting/pynmeagps";
    changelog = "https://github.com/semuconsulting/pynmeagps/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
