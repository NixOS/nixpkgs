{ lib
, stdenv
, attrs
, beautifulsoup4
, buildPythonPackage
, click
, fetchPypi
<<<<<<< HEAD
=======
, intbitset
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-xdist
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, saneyaml
, setuptools-scm
, text-unidecode
<<<<<<< HEAD
=======
, typing
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "commoncode";
<<<<<<< HEAD
  version = "31.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ura55/m/iesqN6kSYmdHB1sbthSHXaFWiQ76wVmyl0E=";
  };

=======
  version = "31.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UWd8fTHVEC5ywETfMIWjfXm4xiNaMrVpwkQ/woeXc0k=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "intbitset >= 2.3.0, < 3.0" "intbitset >= 2.3.0"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    click
<<<<<<< HEAD
    requests
    saneyaml
    text-unidecode
=======
    intbitset
    requests
    saneyaml
    text-unidecode
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/nexB/commoncode/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
=======
    license = licenses.asl20;
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
