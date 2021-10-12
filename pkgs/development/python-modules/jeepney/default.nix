{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, async-timeout
, dbus
, pytest
, pytest-trio
, pytest-asyncio
, testpath
, trio
}:

buildPythonPackage rec {
  pname = "jeepney";
  version = "0.7.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa9e232dfa0c498bd0b8a3a73b8d8a31978304dcef0515adc859d4e096f96f4f";
  };

  checkInputs = [
    async-timeout
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
