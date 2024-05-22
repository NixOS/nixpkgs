{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  freezegun,
  mock,
  pyjwt,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "notifications-python-client";
  version = "9.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = "notifications-python-client";
    rev = "refs/tags/${version}";
    hash = "sha256-qjiI+aTJLOz3XSTHKrpZrJ/wg1xP+V7ww0//xX3Kf1E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    docopt
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "notifications_python_client" ];

  meta = with lib; {
    description = "Python client for the GOV.UK Notify API";
    homepage = "https://github.com/alphagov/notifications-python-client";
    changelog = "https://github.com/alphagov/notifications-python-client/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
