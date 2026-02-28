{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynmeagps";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-78dbqH/Znr1utj1nctwuwabl/HiF1cQWq+obKj/RC5I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pynmeagps" ];

  meta = {
    description = "NMEA protocol parser and generator";
    homepage = "https://github.com/semuconsulting/pynmeagps";
    changelog = "https://github.com/semuconsulting/pynmeagps/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
})
