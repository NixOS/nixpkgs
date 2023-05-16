{ lib
, buildPythonPackage
, fetchFromGitHub
, blurhash
, cryptography
, decorator
, http-ece
, python-dateutil
, python-magic
, pytz
, requests
, six
, pytestCheckHook
, pytest-mock
, pytest-vcr
, requests-mock
}:

buildPythonPackage rec {
  pname = "mastodon-py";
<<<<<<< HEAD
  version = "1.8.1";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-r0AAUjd2MBfZANEpyztMNyaQTlGWvWoUVjJNO1eL218=";
=======
    hash = "sha256-T/yG9LLdttBQ+9vCSit+pyQX/BPqqDXbrTcPfTAUu1U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  propagatedBuildInputs = [
    blurhash
    cryptography
    decorator
    http-ece
    python-dateutil
    python-magic
    pytz
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    requests-mock
  ];

  pythonImportsCheck = [ "mastodon" ];

  meta = with lib; {
    changelog = "https://github.com/halcy/Mastodon.py/blob/${src.rev}/CHANGELOG.rst";
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
