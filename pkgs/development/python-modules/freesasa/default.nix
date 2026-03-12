{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  freesasa,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "freesasa";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freesasa";
    repo = "freesasa-python";
    tag = "v${version}";
    hash = "sha256-/7ymItwXOemY0+IL0k6rWnJI8fAwTFjNXzTV+uf9x9A=";
  };

  postPatch = ''
    ln -s ${freesasa.src}/* lib/
  '';

  build-system = [
    cython
    setuptools
  ];

  env.USE_CYTHON = true;

  pythonImportsCheck = [ "freesasa" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    description = "FreeSASA Python Module";
    homepage = "https://github.com/freesasa/freesasa-python";
    changelog = "https://github.com/freesasa/freesasa-python/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
