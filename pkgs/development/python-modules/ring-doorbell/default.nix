{ lib
, asyncclick
, buildPythonPackage
, fetchPypi
, firebase-messaging
, oauthlib
, poetry-core
, pytest-asyncio
, pytest-mock
, pytest-socket
, pytestCheckHook
, pythonOlder
, pytz
, requests
, requests-mock
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.8.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-sjGN1I/SeI5POkACYBcUA76Fyk7XJln7A6ofg11ygrw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncclick
    oauthlib
    pytz
    requests
    requests-oauthlib
  ];

  passthru.optional-dependencies = {
    listen = [
      firebase-messaging
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "ring_doorbell"
  ];

  meta = with lib; {
    description = "Python library to communicate with Ring Door Bell";
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    changelog = "https://github.com/tchellomello/python-ring-doorbell/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ graham33 ];
  };
}
