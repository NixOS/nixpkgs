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
    rev = "refs/tags/${version}";
    hash = "sha256-rJv/jfdT+JldxR0kKtXQLOI5wXQYSQRWJnqwExwWjTA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libgravatar" ];

  meta = with lib; {
    description = "Library that provides a Python 3 interface for the Gravatar API";
    homepage = "https://github.com/pabluk/libgravatar";
    changelog = "https://github.com/pabluk/libgravatar/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gador ];
  };
}
