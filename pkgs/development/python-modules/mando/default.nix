{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  # Python deps
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mando";
  version = "0.8.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "rubik";
    repo = "mando";
    rev = "v${version}";
    hash = "sha256-FuQZ53ojrQO++0TN0C3hk0LXH+mcfRqtGq8VvfYDufg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "mando" ];

<<<<<<< HEAD
  meta = {
    description = "Create Python CLI apps with little to no effort at all";
    homepage = "https://mando.readthedocs.org";
    changelog = "https://github.com/rubik/mando/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
=======
  meta = with lib; {
    description = "Create Python CLI apps with little to no effort at all";
    homepage = "https://mando.readthedocs.org";
    changelog = "https://github.com/rubik/mando/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
