{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  stdenvNoCC,
  replaceVars,
  buildNpmPackage,
  python,

  # build
  setuptools,

  # dependencies
  aiohttp,
  aiorun,
  atomicwrites,
  coloredlogs,
  orjson,
  home-assistant-chip-clusters,

  # optionals
  cryptography,
  home-assistant-chip-core,
  zeroconf,

  # tests
  aioresponses,
  pytest,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,

  # build options
  withDashboard ? true,
}:

let
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-matter-server";
    tag = version;
    hash = "sha256-vTJGe6OGFM+q9+iovsQMPwkrHNg2l4pw9BFEtSA/vmA=";
  };

  paaCerts = stdenvNoCC.mkDerivation rec {
    pname = "matter-server-paa-certificates";
    version = "1.4.0.0";

    src = fetchFromGitHub {
      owner = "project-chip";
      repo = "connectedhomeip";
      rev = "refs/tags/v${version}";
      hash = "sha256-uJyStkwynPCm1B2ZdnDC6IAGlh+BKGfJW7tU4tULHFo=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp $src/credentials/development/paa-root-certs/* $out/

      runHook postInstall
    '';
  };

  # Maintainer note: building the dashboard requires a python environment with a
  # built version of python-matter-server. To support bundling the dashboard
  # with the python-matter-server, the build is parameterized to build without
  # a dependency on the dashboard, breaking a cyclical dependency. First,
  # python-matter-server is built without the dashboard, then the dashboard is
  # built, then python-matter-server is built again with the dashboard.
  matterServerDashboard =
    let
      pythonWithChip = python.withPackages (ps: [
        ps.home-assistant-chip-clusters
        (ps.python-matter-server.override { withDashboard = false; })
      ]);
    in
    buildNpmPackage {
      pname = "python-matter-server-dashboard";
      inherit src version;

      npmDepsHash = "sha256-IgI1H3VlTq66duplVQqL67SpgxPF2MOowDn+ICMXCik=";

      prePatch = ''
        ${pythonWithChip.interpreter} scripts/generate_descriptions.py

        # cd before the patch phase sets up the npm install hook to find the
        # package.json. The script would need to be patched in order to be used
        # with sourceRoot.
        cd "dashboard"
      '';

      # This package does not contain a normal `npm build` step.
      buildPhase = ''
        env NODE_ENV=production npm exec -- tsc
        env NODE_ENV=production npm exec -- rollup -c
      '';

      installPhase = ''
        runHook preInstall

        install -Dt "$out/" public/*
        # Copy recursive directory structure, which install does not do.
        cp -r dist/web/* "$out/"

        runHook postInstall
      '';
    };
in
buildPythonPackage rec {
  pname = if withDashboard then "python-matter-server" else "python-matter-server-without-dashboard";
  inherit
    src
    version
    ;

  pyproject = true;

  disabled = pythonOlder "3.12";

  patches = [
    (replaceVars ./link-paa-root-certs.patch {
      paacerts = paaCerts;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  ''
  + lib.optionalString withDashboard ''
    substituteInPlace "matter_server/server/server.py" \
      --replace-fail 'Path(__file__).parent.joinpath("../dashboard/")' 'Path("${matterServerDashboard}")'
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "home-assistant-chip-clusters" ];

  dependencies = [
    aiohttp
    aiorun
    atomicwrites
    coloredlogs
    orjson
    home-assistant-chip-clusters
  ];

  optional-dependencies = {
    server = [
      cryptography
      home-assistant-chip-core
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck =
    let
      pythonEnv = python.withPackages (_: dependencies ++ nativeCheckInputs ++ [ pytest ]);
    in
    ''
      export PYTHONPATH=${pythonEnv}/${python.sitePackages}
    '';

  disabledTestPaths = [
    # requires internet access
    "tests/server/ota/test_dcl.py"
  ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/python-matter-server/releases/tag/${src.tag}";
    description = "Python server to interact with Matter";
    mainProgram = "matter-server";
    homepage = "https://github.com/home-assistant-libs/python-matter-server";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
