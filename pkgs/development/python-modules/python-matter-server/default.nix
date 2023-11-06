{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, setuptools
, wheel

# propagates
, aiohttp
, aiorun
, coloredlogs
, dacite
, orjson
, home-assistant-chip-clusters

# optionals
, cryptography
, home-assistant-chip-core

# tests
, python
, pytest
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-matter-server";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-matter-server";
    rev = "refs/tags/${version}";
    hash = "sha256-zCw5sj+UgY0egjXGzcbOb7VATeLY80+8Mv9owmdA+f0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    aiorun
    coloredlogs
    dacite
    orjson
    home-assistant-chip-clusters
  ];

  passthru.optional-dependencies = {
    server = [
      cryptography
      home-assistant-chip-core
    ];
  };

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = let
    pythonEnv = python.withPackages (_: propagatedBuildInputs ++ nativeCheckInputs ++ [ pytest ]);
  in
  ''
    export PYTHONPATH=${pythonEnv}/${python.sitePackages}
  '';

  pytestFlagsArray = [
    # Upstream theymselves limit the test scope
    # https://github.com/home-assistant-libs/python-matter-server/blob/main/.github/workflows/test.yml#L65
    "tests/server"
  ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/python-matter-server/releases/tag/${version}";
    description = "Python server to interact with Matter";
    homepage = "https://github.com/home-assistant-libs/python-matter-server";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
