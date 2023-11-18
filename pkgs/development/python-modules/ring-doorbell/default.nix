{ lib
, asyncclick
, buildPythonPackage
, fetchPypi
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
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-A7FQeeYym0nAQlkbpejpZqd5ZgX2cw3/DbshDxlrivw=";
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
