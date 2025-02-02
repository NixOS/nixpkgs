{
  lib,
  buildPythonPackage,
  environs,
  fetchFromGitHub,
  poetry-core,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  requests,
  tornado,
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "6.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = "deezer-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Y1y8FBxpGpNIWCZbel9fdGLGC9VM9h1BvHtUxCZxp/A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=deezer" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    requests
    tornado
  ];

  nativeCheckInputs = [
    environs
    pytest-mock
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deezer" ];

  disabledTests = [
    # JSONDecodeError issue
    "test_get_user_flow"
    "test_with_language_header"
  ];

  meta = with lib; {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    changelog = "https://github.com/browniebroke/deezer-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
