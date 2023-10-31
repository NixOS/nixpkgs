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
, setuptools
, pytest-cov
}:

buildPythonPackage rec {
  pname = "mastodon-py";
  # tests are broken on last release, check after next release (> 1.8.1)
  version = "unstable-2023-06-24";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    rev = "cd86887d88bbc07de462d1e00a8fbc3d956c0151";
    hash = "sha256-rJocFvtBPrSSny3lwENuRsQdAzi3u8b+SfDNGloniWI=";
  };

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
    pytest-cov
    requests-mock
    setuptools
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
