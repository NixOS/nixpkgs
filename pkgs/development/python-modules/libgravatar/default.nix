{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "libgravatar";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pabluk";
    repo = "libgravatar";
    tag = version;
    hash = "sha256-rJv/jfdT+JldxR0kKtXQLOI5wXQYSQRWJnqwExwWjTA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libgravatar" ];

<<<<<<< HEAD
  meta = {
    description = "Library that provides a Python 3 interface for the Gravatar API";
    homepage = "https://github.com/pabluk/libgravatar";
    changelog = "https://github.com/pabluk/libgravatar/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ gador ];
=======
  meta = with lib; {
    description = "Library that provides a Python 3 interface for the Gravatar API";
    homepage = "https://github.com/pabluk/libgravatar";
    changelog = "https://github.com/pabluk/libgravatar/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gador ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
