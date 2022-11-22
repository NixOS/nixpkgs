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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    rev = "refs/tags/${version}";
    sha256 = "sha256-bzacM5bJa936sBW+hgm9GOezW8cVY2oPaWApqjDYLSo=";
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

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    requests-mock
  ];

  pythonImportsCheck = [ "mastodon" ];

  meta = with lib; {
    description = "Python wrapper for the Mastodon API";
    homepage = "https://github.com/halcy/Mastodon.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
