{ lib
, buildPythonPackage
, fetchFromGitHub
, certifi
, click
, keyring
, keyrings-alt
, pytz
, requests
, six
, tzlocal
, pytest-mock
, pytestCheckHook
, future
}:

buildPythonPackage rec {
  pname = "pyicloud";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "picklepete";
    repo = pname;
    rev = version;
    sha256 = "0bxbhvimwbj2jm8dg7sil8yvln17xgjhvpwr4m783vwfcf76kdmy";
  };

  propagatedBuildInputs = [
    certifi
    click
    future
    keyring
    keyrings-alt
    pytz
    requests
    six
    tzlocal
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    sed -i \
      -e 's!click>=.*!click!' \
      -e 's!keyring>=.*!keyring!' \
      -e 's!keyrings.alt>=.*!keyrings.alt!' \
      -e 's!tzlocal==.*!tzlocal!' \
      requirements.txt
  '';

  meta = with lib; {
    description = "PyiCloud is a module which allows pythonistas to interact with iCloud webservices";
    homepage = "https://github.com/picklepete/pyicloud";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
