{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.21";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = "pypck";
    rev = "refs/tags/${version}";
    hash = "sha256-6Ng+Jw5ZDtkKOftFVhy1uOjzcmeKI5VqWzPn3EkKfGI=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_connection_lost" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pypck" ];

  meta = with lib; {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${version}";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
