{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  pycrdt,
  pycrdt-store,

  # optional-dependencies
  channels,
}:

buildPythonPackage rec {
  pname = "pycrdt-websocket";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-websocket";
    tag = version;
    hash = "sha256-Qux8IxJR1nGbdpGz7RZBKJjYN0qfwfEpd2UDlduOna0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    pycrdt
    pycrdt-store
  ];

  optional-dependencies = {
    django = [ channels ];
  };

  # pycrdt-websocket installs to $out/${python.sitePackages}/pycrdt/websocket, but `pycrdt`' files are not present.
  # Hence, neither pythonImportsCheck nor pytestCheckPhase work in this derivation.
  doCheck = false;

  meta = {
    description = "WebSocket Connector for pycrdt";
    homepage = "https://github.com/y-crdt/pycrdt-websocket";
    changelog = "https://github.com/y-crdt/pycrdt-websocket/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
  };
}
