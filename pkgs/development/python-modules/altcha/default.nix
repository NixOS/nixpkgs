{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "altcha";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altcha-org";
    repo = "altcha-lib-py";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-N30luHhGFkd+XvVKhVnR6degEf0Nm/K/GEaqoEEuZMU=";
=======
    hash = "sha256-QZSj24dyfdgAeHSCWcmWKr35VWjGM3kQyh9o77bHOgY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "altcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Lightweight Python library for creating and verifying ALTCHA challenges";
    homepage = "https://github.com/altcha-org/altcha-lib-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
