{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  dataclasses-json,
  isodate,
  requests,
  requests-oauthlib,
  pytest-cov-stub,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "python-youtube";
  version = "0.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sns-sdks";
    repo = "python-youtube";
    tag = "v${version}";
    hash = "sha256-dK0le/7/hpavrHbk4DaXoIxPHUUJuWuxHIWMZKC4eSM=";
  };

  pythonRelaxDeps = [
    "requests-oauthlib"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    dataclasses-json
    isodate
    requests
    requests-oauthlib
  ];

  pythonImportsCheck = [ "pyyoutube" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    pytest-cov-stub
  ];

  meta = {
    description = "Simple Python wrapper around for YouTube Data API";
    homepage = "https://github.com/sns-sdks/python-youtube";
    changelog = "https://github.com/sns-sdks/python-youtube/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blaggacao ];
  };
}
