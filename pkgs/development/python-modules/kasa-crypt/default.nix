{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  poetry-core,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "kasa-crypt";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "kasa-crypt";
    tag = "v${version}";
    hash = "sha256-eP8GgogyvmrPbsXGWq9RqkinezNGVlDXC/BfgO+dUJ0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=kasa_crypt --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kasa_crypt" ];

  meta = with lib; {
    description = "Fast kasa crypt";
    homepage = "https://github.com/bdraco/kasa-crypt";
    changelog = "https://github.com/bdraco/kasa-crypt/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
