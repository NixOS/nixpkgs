{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-thumbcache";
<<<<<<< HEAD
  version = "1.5";
=======
  version = "1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.thumbcache";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-xWwmkvBKKVCISL5RKzPkdPGo/ganNydymp4FaE9Mr7w=";
=======
    hash = "sha256-HO2s9AxDRmL4TNRYCdkYpWry3i4GNR0K9i5D2Pz3mVQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.thumbcache"
  ];

  disabledTests = [
    # Don't run Windows related tests
    "windows"
    "test_index_type"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows thumbcache";
    homepage = "https://github.com/fox-it/dissect.thumbcache";
    changelog = "https://github.com/fox-it/dissect.thumbcache/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
