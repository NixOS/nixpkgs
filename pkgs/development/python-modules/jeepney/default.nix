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
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d59b6622675ca9e993a6bd38de845051d315f8b0c72cca3aef733a20b648657";
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
