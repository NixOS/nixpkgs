{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
  async-timeout,
  dbus,
  pytest,
  pytest-trio,
  pytest-asyncio,
  testpath,
  trio,
}:

buildPythonPackage rec {
  pname = "jeepney";
  version = "0.9.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zw6ehFYiuB5KKN+UxANFQAJW7GCNDlW7ij/qqRY/VzI=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
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
