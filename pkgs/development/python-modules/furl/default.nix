{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  orderedmultidict,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "furl";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruns";
    repo = "furl";
    tag = "v${version}";
    hash = "sha256-NRkOJlluZjscM4ZhxHoXIzV2A0+mrkaw7rcxfklGCHs=";
  };

  # With python 3.11.4, invalid IPv6 address does throw ValueError
  # https://github.com/gruns/furl/issues/164#issuecomment-1595637359
  postPatch = ''
    substituteInPlace tests/test_furl.py \
      --replace-fail '[0:0:0:0:0:0:0:1:1:1:1:1:1:1:1:9999999999999]' '[2001:db8::9999]'
  '';

  build-system = [ setuptools ];

  dependencies = [
    orderedmultidict
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert '//////path' == '////path'
    # https://github.com/gruns/furl/issues/176
    "test_odd_urls"
  ];

  pythonImportsCheck = [ "furl" ];

  meta = {
    changelog = "https://github.com/gruns/furl/releases/tag/${src.tag}";
    description = "Python library that makes parsing and manipulating URLs easy";
    homepage = "https://github.com/gruns/furl";
    license = lib.licenses.unlicense;
  };
}
