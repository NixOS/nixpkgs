{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  networkx,
  numpy,
  pytest8_3CheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "colormath";
  # Switch to unstable which fixes an deprecation issue with newer numpy
  # versions, should be included in versions > 3.0
  # https://github.com/gtaylor/python-colormath/issues/104
  version = "3.0.0-unstable-2021-04-17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gtaylor";
    repo = "python-colormath";
    rev = "4a076831fd5136f685aa7143db81eba27b2cd19a";
    hash = "sha256-eACVPIQFgiGiVmQ/PjUxP/UH/hBOsCywz5PlgpA4dk4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    networkx
    numpy
  ];

  nativeCheckInputs = [ pytest8_3CheckHook ];

  pythonImportsCheck = [ "colormath" ];

  meta = with lib; {
    description = "Color math and conversion library";
    homepage = "https://github.com/gtaylor/python-colormath";
    changelog = "https://github.com/gtaylor/python-colormath/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jonathanreeve ];
  };
}
