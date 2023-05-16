{ lib
, fetchFromGitHub
, buildPythonPackage
, importlib-metadata
, importlib-resources
, setuptools
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fake-useragent";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fake-useragent";
    repo = "fake-useragent";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-kOvVqdfK9swtjW8D7COrZksLCu1N8sQO8rzx5RZqCT0=";
=======
    hash = "sha256-8fVNko65nP/u9vLGBPfSseKW07b4JC6kCPFCPK2f6wU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i '/addopts/d' pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Up to date simple useragent faker with real world database";
    homepage = "https://github.com/hellysmile/fake-useragent";
    changelog = "https://github.com/fake-useragent/fake-useragent/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
