{ lib
, stdenv
, attrs
, beautifulsoup4
, buildPythonPackage
, click
, fetchPypi
, intbitset
, pytest-xdist
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, saneyaml
, setuptools-scm
, text-unidecode
, typing
}:

buildPythonPackage rec {
  pname = "commoncode";
  version = "31.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iX7HjsbW9rUgG35XalqfXh2+89vEiwish90FGOpkzRo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "intbitset >= 2.3.0, < 3.0" "intbitset >= 2.3.0"
  '';

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    click
    intbitset
    requests
    saneyaml
    text-unidecode
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
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
  ] ++ lib.optionals stdenv.isDarwin [
    # expected result is tailored towards the quirks of upstream's
    # CI environment on darwin
    "test_searchable_paths"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/nexB/commoncode/issues/36
    "src/commoncode/fetch.py"
  ];

  pythonImportsCheck = [
    "commoncode"
  ];

  meta = with lib; {
    description = "A set of common utilities, originally split from ScanCode";
    homepage = "https://github.com/nexB/commoncode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
