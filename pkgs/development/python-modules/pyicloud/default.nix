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
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "picklepete";
    repo = pname;
    rev = version;
    hash = "sha256-2E1pdHHt8o7CGpdG+u4xy5OyNCueUGVw5CY8oicYd5w=";
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

  nativeCheckInputs = [
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
