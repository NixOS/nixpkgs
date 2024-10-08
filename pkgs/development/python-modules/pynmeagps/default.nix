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
  version = "1.0.42";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    rev = "refs/tags/v${version}";
    hash = "sha256-hlGqc4vZ/C98vQwJewK0cfC3zP9xyO0oXXtlyNUDg0Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov --cov-report html --cov-fail-under 98" ""
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
