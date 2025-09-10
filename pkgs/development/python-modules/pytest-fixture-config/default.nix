{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "man-group";
    repo = "pytest-plugins";
    tag = "v${version}";
    hash = "sha256-fLctuuvHVk9GvQB5cTL4/T7GeWzJ2zLJpwZqq9/6C30=";
  };

  postPatch = ''
    cd pytest-fixture-config
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  meta = with lib; {
    changelog = "https://github.com/man-group/pytest-plugins/blob/${src.tag}/CHANGES.md";
    description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
