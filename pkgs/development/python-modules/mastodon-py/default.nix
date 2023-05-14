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
  version = "1.8.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "Mastodon.py";
    rev = "refs/tags/${version}";
    hash = "sha256-T/yG9LLdttBQ+9vCSit+pyQX/BPqqDXbrTcPfTAUu1U=";
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
