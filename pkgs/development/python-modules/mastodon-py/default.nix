{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blurhash,
  cryptography,
  decorator,
  grapheme,
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
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    tag = "v${version}";
    hash = "sha256-i3HMT8cabSl664UK3eopJQ9bDBpGCgbHTvBJkgeoxd8=";
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
    grapheme = [ grapheme ];
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
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # disabledTests = [
  #   "test_notifications_dismiss_pre_2_9_2"
  #   "test_status_card_pre_2_9_2"
  #   "test_stream_user_direct"
  #   "test_stream_user_local"
  # ];

  pythonImportsCheck = [ "mastodon" ];

  meta = with lib; {
    changelog = "https://github.com/halcy/Mastodon.py/blob/${src.tag}/CHANGELOG.rst";
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
