{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  importlib-metadata,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mockfs";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mockfs";
    repo = "mockfs";
    tag = "v${version}";
    hash = "sha256-fTN9HLzlVCn0O8nYy4UUM+JIsYJ3qDPw3h41yhcilJ8=";
  };

  postPatch = ''
    sed -i '/addopts/d' pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ importlib-metadata ];

  pythonImportsCheck = [ "mockfs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Simple mock filesystem for use in unit tests";
    homepage = "https://github.com/mockfs/mockfs";
    changelog = "https://github.com/mockfs/mockfs/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
