{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blurhash,
  cryptography,
  decorator,
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
}:

buildPythonPackage rec {
  pname = "mastodon-py";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    tag = "v${version}";
    hash = "sha256-Sqvn7IIzkGnIjMGek1QS4pLXI+LoKykJsVnr/X1QH7U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    blurhash
    decorator
    python-dateutil
    python-magic
    requests
  ];

  optional-dependencies = {
    blurhash = [ blurhash ];
    webpush = [
      http-ece
      cryptography
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-vcr
    requests-mock
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    "test_notifications_dismiss_pre_2_9_2"
    "test_status_card_pre_2_9_2"
    "test_stream_user_direct"
    "test_stream_user_local"
  ];

  pythonImportsCheck = [ "mastodon" ];

  meta = with lib; {
    changelog = "https://github.com/halcy/Mastodon.py/blob/${src.tag}/CHANGELOG.rst";
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
