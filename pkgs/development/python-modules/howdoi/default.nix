{ stdenv
, lib
, appdirs
, buildPythonPackage
, cachelib
<<<<<<< HEAD
, colorama
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cssselect
, fetchFromGitHub
, keep
, lxml
, pygments
, pyquery
, requests
<<<<<<< HEAD
, rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "howdoi";
<<<<<<< HEAD
  version = "2.0.20";
=======
  version = "2.0.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-u0k+h7Sp2t/JUnfPqRzDpEA+vNXB7CpyZ/SRvk+B9t0=";
=======
    hash = "sha256-uLAc6E8+8uPpo070vsG6Od/855N3gTQMf5pSUvtlh0I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    appdirs
    cachelib
<<<<<<< HEAD
    colorama
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cssselect
    keep
    lxml
    pygments
    pyquery
    requests
<<<<<<< HEAD
    rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
<<<<<<< HEAD
    "test_colorize"
=======
    # AssertionError: "The...
    "test_get_text_with_one_link"
    "test_get_text_without_links"
    # Those tests are failing in the sandbox
    # OSError: [Errno 24] Too many open files
    "test_answers"
    "test_answers_bing"
    "test_colorize"
    "test_json_output"
    "test_missing_pre_or_code_query"
    "test_multiple_answers"
    "test_position"
    "test_unicode_answer"
    "test_answer_links_using_l_option"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "howdoi"
  ];

  meta = with lib; {
<<<<<<< HEAD
    broken = stdenv.isDarwin;
    changelog = "https://github.com/gleitz/howdoi/blob/v${version}/CHANGES.txt";
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
