{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wirerope,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "methodtools";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "methodtools";
    rev = version;
    hash = "sha256-Y5VdYVSb3A+32waUUoIDDGW+AhRapN71pebTTlJC0es=";
  };

  build-system = [ setuptools ];

  dependencies = [ wirerope ];

  pythonImportsCheck = [ "methodtools" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

<<<<<<< HEAD
  meta = {
    description = "Expands the functools lru_cache to classes";
    homepage = "https://github.com/youknowone/methodtools";
    changelog = "https://github.com/youknowone/methodtools/releases/tag/${version}";
    license = lib.licenses.bsd2WithViews;
    maintainers = with lib.maintainers; [ pbsds ];
=======
  meta = with lib; {
    description = "Expands the functools lru_cache to classes";
    homepage = "https://github.com/youknowone/methodtools";
    changelog = "https://github.com/youknowone/methodtools/releases/tag/${version}";
    license = licenses.bsd2WithViews;
    maintainers = with maintainers; [ pbsds ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
