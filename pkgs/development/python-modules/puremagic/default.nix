{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.30";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "puremagic";
    tag = version;
    hash = "sha256-k2xrcML8XxI9cMTQTv0pDLkOrmEr5mbDnVsyWuD1rEc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "puremagic" ];

<<<<<<< HEAD
  meta = {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    changelog = "https://github.com/cdgriffith/puremagic/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    changelog = "https://github.com/cdgriffith/puremagic/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
