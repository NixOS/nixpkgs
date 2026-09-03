{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  setuptools,
  cython,
  ciso8601,
  tzdata,
  lz4,
  tzlocal,
  zstd,
  clickhouse-cityhash,
  stdenv,
  nix-update-script,
  nixosTests,
}:

buildPythonPackage (finalAttrs: {
  pname = "asynch";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = "asynch";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-iLhhk7EiNHMVzxlw7HWjS00GwZ8cRXPz3jih1edWde4=";
  };

  disabled = pythonOlder "3.11";

  build-system = [
    poetry-core
    setuptools
    cython
  ];

  dependencies = [
    ciso8601
    tzlocal
  ]
  ++ lib.optionals (stdenv.hostPlatform.isWindows) [
    tzdata
  ];

  optional-dependencies = {
    compression = [
      clickhouse-cityhash
      lz4
    ]
    ++ lib.optionals (pythonOlder "3.14") [
      zstd
    ];
  };

  pythonImportsCheck = [
    "asynch"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) asynch;
    };
  };

  meta = {
    description = "Asyncio driver for ClickHouse with native TCP support";
    homepage = "https://github.com/long2ice/asynch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jlesquembre
      joaosreis
    ];
  };
})
