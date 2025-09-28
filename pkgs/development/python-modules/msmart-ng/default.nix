{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  httpx,
  pycryptodome,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "msmart-ng";
  version = "2025.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    tag = version;
    hash = "sha256-+A3Mk/S5FZLe3y5J3olZ+kBlIlkLXlX92IdrvudFriE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    httpx
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  env.CI = true;

  pythonImportsCheck = [ "msmart" ];

  meta = with lib; {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${src.tag}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with maintainers; [
      hexa
      emilylange
    ];
  };
}
