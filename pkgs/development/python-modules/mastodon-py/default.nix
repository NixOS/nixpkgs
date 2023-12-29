{ lib
, buildPythonPackage
, fetchFromGitHub
, blurhash
, cryptography
, decorator
, http-ece
, python-dateutil
, python-magic
, requests
, six
, pytestCheckHook
, pytest-mock
, pytest-vcr
, requests-mock
, setuptools
}:

buildPythonPackage rec {
  pname = "mastodon-py";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    rev = "refs/tags/${version}";
    hash = "sha256-r0AAUjd2MBfZANEpyztMNyaQTlGWvWoUVjJNO1eL218=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    blurhash
    decorator
    python-dateutil
    python-magic
    requests
    six
  ];

  passthru.optional-dependencies = {
    blurhash = [
      blurhash
    ];
    webpush = [
      http-ece
      cryptography
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    requests-mock
    setuptools
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    "test_notifications_dismiss_pre_2_9_2"
    "test_status_card_pre_2_9_2"
    "test_stream_user_direct"
    "test_stream_user_local"
  ];

  pythonImportsCheck = [ "mastodon" ];

  meta = with lib; {
    changelog = "https://github.com/halcy/Mastodon.py/blob/${src.rev}/CHANGELOG.rst";
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
