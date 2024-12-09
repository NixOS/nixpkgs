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
    rev = "refs/tags/${version}";
    hash = "sha256-8MNeOcYPEYAfghZN/K/1v/tAAdgz/fCvuVnBoru+81Q=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail " --cov" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "paste.deploy" ];

  meta = with lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = "https://github.com/Pylons/pastedeploy";
    changelog = "https://github.com/Pylons/pastedeploy/blob/${version}/docs/news.rst";
    license = licenses.mit;
    maintainers = teams.openstack.members;
  };
}
