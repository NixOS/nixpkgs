{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  requests,
  requests-futures,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "py-melissa-climate";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "py-melissa-climate";
    tag = "V${version}";
    hash = "sha256-Z1A0G3g8dyoG+zUxUTqI/OxczvUVy2kSI04YP0WeXso=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires=['setuptools-markdown']," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    requests-futures
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Disable failing tests due to upstream bugs
    "test_have_connection"
    "test_send"
    "test_send_ok"
  ];

  pythonImportsCheck = [ "melissa" ];

  meta = {
    description = "API wrapper for Melissa Climate";
    homepage = "https://github.com/kennedyshead/py-melissa-climate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
