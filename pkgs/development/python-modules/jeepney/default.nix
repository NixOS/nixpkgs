{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, dbus
, pytest
, pytest-trio
, pytest-asyncio
, testpath
, trio
}:

buildPythonPackage rec {
  pname = "jeepney";
  version = "0.7.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1237cd64c8f7ac3aa4b3f332c4d0fb4a8216f39eaa662ec904302d4d77de5a54";
  };

  checkInputs = [
    dbus
    pytest
    pytest-trio
    pytest-asyncio
    testpath
    trio
  ];

  checkPhase = ''
    runHook preCheck

    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- pytest

    runHook postCheck
  '';

  pythonImportsCheck = [
    "jeepney"
    "jeepney.auth"
    "jeepney.io"
    "jeepney.io.asyncio"
    "jeepney.io.blocking"
    "jeepney.io.threading"
    "jeepney.io.trio"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/takluyver/jeepney";
    description = "Pure Python DBus interface";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
