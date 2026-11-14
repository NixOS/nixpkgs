{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blurhash,
  cryptography,
  decorator,
  graphemeu,
  http-ece,
  python-dateutil,
  python-magic,
  requests,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  pytest-vcr,
  requests-mock,
  setuptools,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "mastodon-py";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    tag = "v${version}";
    hash = "sha256-c0AHqqb9nBKKccoEPx/jsUm4szGP/CEdBYQbFEAdEF4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    python-dateutil
    requests
  ];

  optional-dependencies = {
    blurhash = [ blurhash ];
    grapheme = [ graphemeu ];
    magic = [ python-magic ];
    webpush = [
      http-ece
      cryptography
    ];
    websocket_streaming = [ websocket-client ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-vcr
    requests-mock
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "mastodon" ];

  meta = {
    changelog = "https://github.com/halcy/Mastodon.py/blob/${src.tag}/CHANGELOG.rst";
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
