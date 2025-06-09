{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pastedeploy";
  version = "3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Pylons";
    repo = "pastedeploy";
    tag = version;
    hash = "sha256-yR7UxAeF0fQrbU7tl29GpPeEAc4YcxHdNQWMD67pP3g=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail " --cov" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "paste.deploy" ];

  meta = {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = "https://github.com/Pylons/pastedeploy";
    changelog = "https://github.com/Pylons/pastedeploy/blob/${src.tag}/docs/news.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.openstack ];
  };
}
