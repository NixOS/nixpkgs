{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
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
  version = "0.9";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "takluyver";
    repo = "jeepney";
    tag = version;
    hash = "sha256-d8w/4PtDviTYDHO4EwaVbxlYk7CXtlv7vuR+o4LhfRs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    dbus
    pytest
    pytest-trio
    pytest-asyncio
    testpath
    trio
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  checkPhase = ''
    runHook preCheck

    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- pytest ${lib.optionalString stdenv.hostPlatform.isDarwin "--ignore=jeepney/io/tests"}

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
    changelog = "https://gitlab.com/takluyver/jeepney/-/blob/${src.tag}/docs/release-notes.rst";
    homepage = "https://gitlab.com/takluyver/jeepney";
    description = "Pure Python DBus interface";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
