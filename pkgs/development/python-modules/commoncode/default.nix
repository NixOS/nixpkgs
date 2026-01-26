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
  requests,
  saneyaml,
  setuptools-scm,
  text-unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "commoncode";
  version = "32.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "commoncode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A2FE+qhLQahuAtptP3hCnIUgh7j61Wf02avO6DM0b5E=";
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

  meta = {
    description = "Set of common utilities, originally split from ScanCode";
    homepage = "https://github.com/nexB/commoncode";
    changelog = "https://github.com/nexB/commoncode/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
