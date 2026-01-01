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
<<<<<<< HEAD
  version = "2025.12.0";
=======
  version = "2025.9.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-zRTs6nRgI5ixbHzDXfAjJ2JW/9y+b7vzAyUGk120xj4=";
=======
    hash = "sha256-+A3Mk/S5FZLe3y5J3olZ+kBlIlkLXlX92IdrvudFriE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${src.tag}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = lib.licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${src.tag}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hexa
      emilylange
    ];
  };
}
