{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  mock,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  responses,
  setuptools,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "amcrest";
  version = "1.9.8";
  pyproject = true;

  # Still uses distutils, https://github.com/tchellomello/python-amcrest/issues/234
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = "refs/tags/${version}";
    hash = "sha256-v0jWEZo06vltEq//suGrvJ/AeeDxUG5CCFhbf03q34w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argcomplete
    httpx
    requests
    urllib3
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "amcrest" ];

  meta = with lib; {
    description = "Python module for Amcrest and Dahua Cameras";
    homepage = "https://github.com/tchellomello/python-amcrest";
    changelog = "https://github.com/tchellomello/python-amcrest/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
