{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  httpx,
  mock,
  pytestCheckHook,
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

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = "refs/tags/${version}";
    hash = "sha256-v0jWEZo06vltEq//suGrvJ/AeeDxUG5CCFhbf03q34w=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/tchellomello/python-amcrest/pull/235
      name = "replace-distutils.patch";
      url = "https://github.com/tchellomello/python-amcrest/commit/ec56049c0f5b49bc4c5bcf0acb7fea89ec1c1df4.patch";
      hash = "sha256-ym+Bn795y+JqhNMk4NPnOVr3DwO9DkUV0d9LEaz3CMo=";
    })
  ];

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
