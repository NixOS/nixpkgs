<<<<<<< HEAD
{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:
=======
{ lib, buildPythonPackage, fetchPypi, requests, beautifulsoup4, pytest, requests-mock,
  pytest-runner }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "favicon";
  version = "0.7.0";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bWtaeN4qDQCEWJ9ofzhLLs1qZScJP+xWRAOxowYF16g=";
  };

  postPatch = ''
    sed -i "/pytest-runner/d" setup.py
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "favicon"
  ];

  meta = with lib; {
    description = "Find a website's favicon";
    homepage = "https://github.com/scottwernervt/favicon";
    changelog = "https://github.com/scottwernervt/favicon/blob/${version}/CHANGELOG.rst";
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d6b5a78de2a0d0084589f687f384b2ecd6a6527093fec564403b1a30605d7a8";
  };

  buildInputs = [ pytest-runner ];
  nativeCheckInputs = [ pytest requests-mock ];
  propagatedBuildInputs = [ requests beautifulsoup4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Find a website's favicon";
    homepage = "https://github.com/scottwernervt/favicon";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
