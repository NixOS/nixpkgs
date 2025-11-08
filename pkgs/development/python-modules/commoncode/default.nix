{
  lib,
  stdenv,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  requests,
  saneyaml,
  setuptools-scm,
  text-unidecode,
}:

buildPythonPackage rec {
  pname = "commoncode";
  version = "32.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "commoncode";
    tag = "v${version}";
    hash = "sha256-FL9t8r53AJLR5D2XSEOq7qVHgvvHIbtPW5iVpSQCVsQ=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  dependencies = [
    attrs
    beautifulsoup4
    click
    requests
    saneyaml
    text-unidecode
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # chinese character translates different into latin
    "test_safe_path_posix_style_chinese_char"
    # OSError: [Errno 84] Invalid or incomplete multibyte or wide character
    "test_os_walk_can_walk_non_utf8_path_from_unicode_path"
    "test_resource_iter_can_walk_non_utf8_path_from_unicode_path"
    "test_walk_can_walk_non_utf8_path_from_unicode_path"
    "test_resource_iter_can_walk_non_utf8_path_from_unicode_path_with_dirs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # expected result is tailored towards the quirks of upstream's
    # CI environment on darwin
    "test_searchable_paths"
  ];

  pythonImportsCheck = [ "commoncode" ];

  meta = with lib; {
    description = "Set of common utilities, originally split from ScanCode";
    homepage = "https://github.com/nexB/commoncode";
    changelog = "https://github.com/nexB/commoncode/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
