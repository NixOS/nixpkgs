{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-twitch-client";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsifrer";
    repo = "python-twitch-client";
    rev = "refs/tags/${version}";
    sha256 = "sha256-gxBpltwExb9bg3HLkz/MNlP5Q3/x97RHxhbwNqqanIM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "twitch" ];

  disabledTests = [
    # Tests require network access
    "test_delete_from_community"
    "test_update"
  ];

  meta = with lib; {
    description = "Python wrapper for the Twitch API";
    homepage = "https://github.com/tsifrer/python-twitch-client";
    changelog = "https://github.com/tsifrer/python-twitch-client/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
