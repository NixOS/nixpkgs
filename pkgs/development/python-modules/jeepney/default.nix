{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  dbus,
  pytest,
  pytest-trio,
  pytest-asyncio,
  testpath,
  trio,
}:

buildPythonPackage (finalAttrs: {
  pname = "jeepney";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "takluyver";
    repo = "jeepney";
    tag = finalAttrs.version;
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

  meta = {
    changelog = "https://gitlab.com/takluyver/jeepney/-/blob/${finalAttrs.src.tag}/docs/release-notes.rst";
    homepage = "https://gitlab.com/takluyver/jeepney";
    description = "Pure Python DBus interface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
