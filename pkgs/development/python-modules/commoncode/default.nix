{
  lib,
  stdenv,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "31.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "commoncode";
    rev = "refs/tags/v${version}";
    hash = "sha256-4ZgyNlMj1i1fRru4wgDOyP3qzbne8D2eH/tFI60kgrE=";
  };

  patches = [
    # https://github.com/nexB/commoncode/pull/66
    (fetchpatch2 {
      url = "https://github.com/nexB/commoncode/commit/4f87b3c9272dcf209b9c4b997e98b58e0edaf570.patch";
      hash = "sha256-loUtAww+SK7kMt5uqZmLQ8Wg/OqB7LWVA4BiztnwHsA=";
    })
  ];

  dontConfigure = true;

  build-system = [ setuptools-scm ];

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

  disabledTests =
    [
      # chinese character translates different into latin
      "test_safe_path_posix_style_chinese_char"
      # OSError: [Errno 84] Invalid or incomplete multibyte or wide character
      "test_os_walk_can_walk_non_utf8_path_from_unicode_path"
      "test_resource_iter_can_walk_non_utf8_path_from_unicode_path"
      "test_walk_can_walk_non_utf8_path_from_unicode_path"
      "test_resource_iter_can_walk_non_utf8_path_from_unicode_path_with_dirs"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
