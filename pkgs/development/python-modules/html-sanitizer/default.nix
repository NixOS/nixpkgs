{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hatchling
, lxml
, beautifulsoup4
, pytestCheckHook
, pythonOlder
=======
, lxml
, beautifulsoup4
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
<<<<<<< HEAD
  version = "2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "1.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-WU5wdTvCzYEw1eiuTLcFImvydzxWANfmDQCmEgyU9h4=";
  };

  nativeBuildInputs = [
    hatchling
  ];

=======
    rev = version;
    hash = "sha256-1JSdi1PFM+N+UuEPfgWkOZw8S2PZ4ntadU0wnVJNnjw=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    lxml
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "html_sanitizer/tests.py"
  ];

  disabledTests = [
    # Tests are sensitive to output
    "test_billion_laughs"
    "test_10_broken_html"
  ];

  pythonImportsCheck = [
    "html_sanitizer"
  ];

  meta = with lib; {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
<<<<<<< HEAD
    changelog = "https://github.com/matthiask/html-sanitizer/blob/${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
