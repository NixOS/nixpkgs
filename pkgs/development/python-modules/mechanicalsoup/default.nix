{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytest-httpbin
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "mechanicalsoup";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MechanicalSoup";
    repo = "MechanicalSoup";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-iZ2nwBxikf0cTTlxzcGvHJim4N6ZEqIhlK7t1WAYdms=";
  };

=======
    rev = "v${version}";
    hash = "sha256-Q5oDAgAZYYUYqjDByXNXFNVKmRyjzIGVE4LN9j8vk4c=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ];

  nativeCheckInputs = [
    pytest-httpbin
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # Is in setup_requires but not used in setup.py
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --cov --cov-config .coveragerc --flake8" ""
  '';

<<<<<<< HEAD
  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-httpbin
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mechanicalsoup"
  ];

  meta = with lib; {
    description = "Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
<<<<<<< HEAD
    changelog = "https://github.com/MechanicalSoup/MechanicalSoup/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich fab ];
  };
}
