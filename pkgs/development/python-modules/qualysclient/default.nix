{
  lib,
  buildPythonPackage,
  setuptools,
  certifi,
  charset-normalizer,
  fetchFromGitHub,
  idna,
  lxml,
  pytest-mock,
  pytestCheckHook,
  requests,
  responses,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "qualysclient";
  version = "0.0.4.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "woodtechie1428";
    repo = "qualysclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2m/WHxkomHBudWpFpsgXHN8n+hfLU+lf9fvxhh/3HjA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=__version__," 'version="${finalAttrs.version}",'
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    charset-normalizer
    idna
    lxml
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "qualysclient" ];

  meta = {
    description = "Python SDK for interacting with the Qualys API";
    homepage = "https://qualysclient.readthedocs.io/";
    changelog = "https://github.com/woodtechie1428/qualysclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
