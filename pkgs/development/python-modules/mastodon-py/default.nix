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
}:

buildPythonPackage rec {
  pname = "mastodon-py";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    tag = "v${version}";
    hash = "sha256-RsSM7TkNwsirT1ksaXP/IKOmrpPrNGh/16S77Up+3MM=";
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
    grapheme = [ graphemeu ];
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
